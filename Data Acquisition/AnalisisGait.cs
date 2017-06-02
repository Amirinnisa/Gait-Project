using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using WiimoteLib;
using System.Drawing.Drawing2D;
using System.Runtime.InteropServices;
/*using AForge.Video;
using AForge.Video.VFW;
using AForge.Video.DirectShow;*/

namespace Parameter_Gait
{
    public partial class AnalisisGait : Form
    {
        // map a wiimote to a specific state user control dealie
        Dictionary<Guid, parameter> mWiimoteMap = new Dictionary<Guid, parameter>();
        WiimoteCollection mWC;
        /*public FilterInfoCollection VideoCaptureDevices;
        public VideoCaptureDevice FinalVideo;*/
        
        public AnalisisGait()
        {   InitializeComponent();}

        private void AnalisisGait_Load(object sender, EventArgs e)
        {
            // find all wiimotes connected to the system
            mWC = new WiimoteCollection();
            int index = 1;
         
            try
            {  mWC.FindAllWiimotes();}
            catch (WiimoteNotFoundException ex)
            {    MessageBox.Show(ex.Message, "Wiimote not found error",
	 MessageBoxButtons.OK, MessageBoxIcon.Error); }
            catch (WiimoteException ex)
            {
                MessageBox.Show(ex.Message, "Wiimote error", MessageBoxButtons.OK,
	 MessageBoxIcon.Error);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Unknown error", MessageBoxButtons.OK,
	 MessageBoxIcon.Error);
            }

            foreach (Wiimote wm in mWC)
            {
                // create a new tab
                TabPage tp = new TabPage("Wiimote " + index);
                tabWiimotes.TabPages.Add(tp);

                // create a new user control
                parameter wi = new parameter(wm);
                tp.Controls.Add(wi);

                // setup the map from this wiimote's ID to that control
                mWiimoteMap[wm.ID] = wi;

                // connect it and set it up as always
                wm.WiimoteChanged += wm_WiimoteChanged;
                wm.WiimoteExtensionChanged += wm_WiimoteExtensionChanged;
                
                wm.Connect();
                if (wm.WiimoteState.ExtensionType != ExtensionType.BalanceBoard)
                    wm.SetReportType(InputReport.IRExtensionAccel,
		 IRSensitivity.Maximum, true);

                wm.SetLEDs(index++);
            }
        }

        void wm_WiimoteChanged(object sender, WiimoteChangedEventArgs e)
        {
            parameter wi = mWiimoteMap[((Wiimote)sender).ID];
            wi.UpdateState(e);
        }

     void wm_WiimoteExtensionChanged(object sender, WiimoteExtensionChangedEventArgs e)
        {
            // find the control for this Wiimote
            parameter wi = mWiimoteMap[((Wiimote)sender).ID];
            wi.UpdateExtension(e);

            if (e.Inserted)
                ((Wiimote)sender).SetReportType(InputReport.IRExtensionAccel, true);
            else
                ((Wiimote)sender).SetReportType(InputReport.IRAccel, true);
        }

        private void AnalisisGait_FormClosing(object sender, FormClosingEventArgs e)
        {
            foreach (Wiimote wm in mWC)
                wm.Disconnect();
        }
    }
}
