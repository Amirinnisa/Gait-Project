using System;
using System.IO;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Drawing.Imaging;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Windows.Forms;
using WiimoteLib;
using Microsoft.Office.Core;
using Excel = Microsoft.Office.Interop.Excel;


namespace Parameter_Gait
{
    public partial class parameter : UserControl
    {
         //inisiasi delegate untuk meng-update wiimote state & perubahan extension
        private delegate void UpdateWiimoteStateDelegate(WiimoteChangedEventArgs args);
        private delegate void UpdateExtensionChangedDelegate(WiimoteExtensionChangedEventArgs args);

        private Wiimote mWiimote;
        private int rollfast = 0; private int pitchfast = 0; private int yawfast = 0;
        private int toecek = 0; private int heelcek = 0;

        double[] state = new double[14];
                
        public parameter()
        {
            InitializeComponent();
            //g = Graphics.FromImage(b);
        }
        /* WIIMOTE: fungsi-fungsi untuk Wiimote
         */
        public parameter(Wiimote wm):this ()
        {
             mWiimote = wm;
        }

        //BEGININVOKE prosedur untuk memanggil delegate update wiimote state
        public void UpdateState(WiimoteChangedEventArgs args)
        {
            BeginInvoke(new UpdateWiimoteStateDelegate(UpdateWiimoteChanged), args);
        }

        //BEGININVOKE prosedur untuk memanggil delegate update perubahan extension
        public void UpdateExtension(WiimoteExtensionChangedEventArgs args)
        {
            BeginInvoke(new UpdateExtensionChangedDelegate(UpdateExtensionChanged), args);
        }

        private void chkLED_CheckedChanged(object sender, EventArgs e)
        {
            mWiimote.SetLEDs(chkLED1.Checked, chkLED2.Checked, chkLED3.Checked, chkLED4.Checked);
        }

        
        //prosedur meng-update perubahan wiimote  state
        private void UpdateWiimoteChanged(WiimoteChangedEventArgs args)
        {
            WiimoteState ws = args.WiimoteState;
            
            toe.Checked = ws.ButtonState.Left;
            if (ws.ButtonState.Left)
            { toecek = 1; }
            else
            { toecek = 0; }
            
            heel.Checked = ws.ButtonState.Up;
            if (ws.ButtonState.Up)
            { heelcek = 1; }
            else
            { heelcek = 0; }
            
            lblAccel.Text = ws.AccelState.Values.ToString();

            switch (ws.ExtensionType)
            {   //extension yang digunakan hanya MotionPlus; nunchuck, balance board, classic controllers, dll. tidak digunakan
                case ExtensionType.MotionPlus:
                    lblMotionPlus.Text = ws.MotionPlusState.RawValues.ToString();
                    clbSpeed.SetItemChecked(0, ws.MotionPlusState.YawFast);
                    clbSpeed.SetItemChecked(1, ws.MotionPlusState.PitchFast);
                    clbSpeed.SetItemChecked(2, ws.MotionPlusState.RollFast);
                    if (ws.MotionPlusState.YawFast)
                    { yawfast = 1; }
                    else
                    { yawfast = 0; }

                    if (ws.MotionPlusState.PitchFast)
                    { pitchfast = 1; }
                    else
                    { pitchfast = 0; }

                    if (ws.MotionPlusState.RollFast)
                    { rollfast = 1; }
                    else
                    { rollfast = 0; }
                    break;
            }

            //g.Clear(Color.Black);

            pbBattery.Value = (ws.Battery > 0xc8 ? 0xc8 : (int)ws.Battery);
            lblBattery.Text = ws.Battery.ToString();
            lblDevicePath.Text = "Device Path: " + mWiimote.HIDDevicePath;

            state[1] = rollfast;
            state[2] = pitchfast;
            state[3] = yawfast;
            state[4] = (double)(ws.AccelState.Values.X * 9.8);
            state[5] = (double)(ws.AccelState.Values.Y * 9.8);
            state[6] = (double)(ws.AccelState.Values.Z * 9.8);
            state[7] = (double)(ws.MotionPlusState.RawValues.X);
            state[8] = (double)(ws.MotionPlusState.RawValues.Y);
            state[9] = (double)(ws.MotionPlusState.RawValues.Z);
            state[10] = toecek;
            state[11] = heelcek;
            
            chkLED1.Checked = ws.LEDState.LED1;
            chkLED2.Checked = ws.LEDState.LED2;
            chkLED3.Checked = ws.LEDState.LED3;
            chkLED4.Checked = ws.LEDState.LED4;
        }

        //prosedur meng-update perubahan extension
        private void UpdateExtensionChanged(WiimoteExtensionChangedEventArgs args)
        {
            chkExtension.Text = args.ExtensionType.ToString();
            chkExtension.Checked = args.Inserted;
        }

        public Wiimote Wiimote
        {
            set { mWiimote = value; }
        }

        /* fungsi-fungsi user control untuk form
         */
        private void initMPlus_Click(object sender, EventArgs e)
        {
            mWiimote.InitializeMotionPlus();
        }

        System.Globalization.CultureInfo oldCI;
        //get the old CurrenCulture and set the new, en-US
        void SetNewCurrentCulture()
        {
            oldCI = System.Threading.Thread.CurrentThread.CurrentCulture;
            System.Threading.Thread.CurrentThread.CurrentCulture = new System.Globalization.CultureInfo("en-US");
        }
        //reset Current Culture back to the originale
        void ResetCurrentCulture()
        {
            System.Threading.Thread.CurrentThread.CurrentCulture = oldCI;
        }

        public void data()
        {
            Stopwatch sw = new Stopwatch();
            //buat kalarray
            int col = 0;
            double[,] dataarray = new double[2100, 12];
            sw.Start();
            while (sw.ElapsedMilliseconds<21000)
            {
                swcounter.Text = sw.ElapsedMilliseconds.ToString();
                swsecond.Text = sw.Elapsed.Seconds.ToString();
                //isi kolom dataarray 0 - 11
                dataarray[col, 0] = sw.ElapsedMilliseconds;
                for (int j = 1; j < 12; j++)
                {
                    dataarray[col, j] = state[j];
                }
                PauseForMilliSeconds(10);
                col++;
            }
            sw.Stop(); 
        
            SetNewCurrentCulture();
            Excel.Application myExcelApp = new Excel.ApplicationClass();
            myExcelApp.Visible = true;
            object misValue = System.Reflection.Missing.Value;
            Excel.Workbooks myExcelWorkbooks = myExcelApp.Workbooks;
            Excel.Workbook myExcelWorkbook = myExcelWorkbooks.Add(misValue);

            Excel.Worksheet kal = (Excel.Worksheet)myExcelWorkbook.ActiveSheet;

            kal.Cells[1, 1] = "Waktu";
            kal.Cells[1, 2] = "FastBit Roll";
            kal.Cells[1, 3] = "FastBit Pitch";
            kal.Cells[1, 4] = "FastBit Yaw";
            kal.Cells[1, 5] = "AX";
            kal.Cells[1, 6] = "AY";
            kal.Cells[1, 7] = "AZ";
            kal.Cells[1, 8] = "GX";
            kal.Cells[1, 9] = "GY";
            kal.Cells[1, 10] = "GZ";
            kal.Cells[1, 11] = "toe";
            kal.Cells[1, 12] = "heel";

            kal.get_Range("A2", "L2101").Value2 = dataarray;
            ResetCurrentCulture();
        }
        public static DateTime PauseForMilliSeconds(int MilliSecondsToPauseFor)
                {
                    System.DateTime ThisMoment = System.DateTime.Now;
                    System.TimeSpan duration = new System.TimeSpan(0, 0, 0, 0, MilliSecondsToPauseFor);
                    System.DateTime AfterWards = ThisMoment.Add(duration);

                    while (AfterWards >= ThisMoment)
                    {
                        System.Windows.Forms.Application.DoEvents();
                        ThisMoment = System.DateTime.Now;
                    }
                    return System.DateTime.Now;
                }
        private void rekam_Click(object sender, EventArgs e)
        {  data();}
   }
} 
