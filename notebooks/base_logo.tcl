
################################################################
# This is a generated script based on design: base
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2018.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source base_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xczu7ev-ffvc1156-2-e
   set_property BOARD_PART xilinx.com:zcu104:part0:1.0 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name base

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axi_intc:4.1\
xilinx.com:ip:axi_register_slice:2.1\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:hls:filter_pipeline:1.0\
xilinx.com:ip:axi_iic:2.0\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:xlslice:1.0\
xilinx.com:ip:mdm:3.2\
xilinx.com:hls:optical_flow:1.0\
xilinx.com:ip:util_ds_buf:2.1\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:pr_axi_shutdown_manager:1.0\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:zynq_ultra_ps_e:3.2\
xilinx.com:user:dff_en_reset_vector:1.0\
xilinx.com:user:io_switch:1.1\
xilinx.com:ip:microblaze:10.0\
xilinx.com:ip:axi_bram_ctrl:4.0\
xilinx.com:ip:axi_quad_spi:3.2\
xilinx.com:ip:axi_timer:2.0\
xilinx.com:ip:axi_vdma:6.3\
xilinx.com:ip:axis_subset_converter:1.1\
xilinx.com:ip:lmb_v10:3.0\
xilinx.com:ip:blk_mem_gen:8.4\
xilinx.com:ip:lmb_bram_if_cntlr:4.0\
xilinx.com:hls:color_convert_2:1.0\
xilinx.com:ip:v_hdmi_rx_ss:3.1\
xilinx.com:hls:pixel_pack_2:1.0\
xilinx.com:ip:axis_register_slice:1.1\
xilinx.com:ip:v_hdmi_tx_ss:3.1\
xilinx.com:hls:logo_output:1.0\
xilinx.com:ip:v_mix:3.0\
xilinx.com:ip:v_tpg:7.0\
xilinx.com:ip:vid_phy_controller:2.2\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: phy
proc create_hier_cell_phy { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_phy() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 DRU_CLK_IN
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 vid_phy_axi4lite
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 vid_phy_rx_axi4s_ch0
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 vid_phy_rx_axi4s_ch1
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 vid_phy_rx_axi4s_ch2
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 vid_phy_status_sb_rx
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 vid_phy_status_sb_tx
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 vid_phy_tx_axi4s_ch0
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 vid_phy_tx_axi4s_ch1
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 vid_phy_tx_axi4s_ch2

  # Create pins
  create_bd_pin -dir I -type clk HDMI_RX_CLK_N_IN
  create_bd_pin -dir I -type clk HDMI_RX_CLK_P_IN
  create_bd_pin -dir I -from 2 -to 0 HDMI_RX_DAT_N_IN
  create_bd_pin -dir I -from 2 -to 0 HDMI_RX_DAT_P_IN
  create_bd_pin -dir O -type clk HDMI_TX_CLK_N_OUT
  create_bd_pin -dir O -type clk HDMI_TX_CLK_P_OUT
  create_bd_pin -dir O -from 2 -to 0 HDMI_TX_DAT_N_OUT
  create_bd_pin -dir O -from 2 -to 0 HDMI_TX_DAT_P_OUT
  create_bd_pin -dir I IDT_8T49N241_LOL_IN
  create_bd_pin -dir O -type clk RX_REFCLK_N_OUT
  create_bd_pin -dir O -type clk RX_REFCLK_P_OUT
  create_bd_pin -dir I -type rst TX_EN_OUT
  create_bd_pin -dir I -type clk TX_REFCLK_N_IN
  create_bd_pin -dir I -type clk TX_REFCLK_P_IN
  create_bd_pin -dir O -type intr irq2
  create_bd_pin -dir O -type clk rx_video_clk
  create_bd_pin -dir I -type clk s_axi_cpu_aclk
  create_bd_pin -dir I -type rst s_axi_cpu_aresetn
  create_bd_pin -dir O -type clk tx_video_clk
  create_bd_pin -dir O -type clk vid_phy_rx_axi4s_aclk
  create_bd_pin -dir O -type clk vid_phy_tx_axi4s_aclk

  # Create instance: dru_ibufds_gt_odiv2, and set properties
  set dru_ibufds_gt_odiv2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 dru_ibufds_gt_odiv2 ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {BUFG_GT} \
 ] $dru_ibufds_gt_odiv2

  # Create instance: gt_refclk_buf, and set properties
  set gt_refclk_buf [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 gt_refclk_buf ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {IBUFDSGTE} \
 ] $gt_refclk_buf

  # Create instance: vcc_const0, and set properties
  set vcc_const0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 vcc_const0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {1} \
 ] $vcc_const0

  # Create instance: vid_phy_controller, and set properties
  set vid_phy_controller [ create_bd_cell -type ip -vlnv xilinx.com:ip:vid_phy_controller:2.2 vid_phy_controller ]
  set_property -dict [ list \
   CONFIG.CHANNEL_SITE {X0Y16} \
   CONFIG.C_INPUT_PIXELS_PER_CLOCK {2} \
   CONFIG.C_INT_HDMI_VER_CMPTBLE {3} \
   CONFIG.C_NIDRU {true} \
   CONFIG.C_NIDRU_REFCLK_SEL {3} \
   CONFIG.C_RX_PLL_SELECTION {0} \
   CONFIG.C_RX_REFCLK_SEL {1} \
   CONFIG.C_Rx_Protocol {HDMI} \
   CONFIG.C_TX_PLL_SELECTION {6} \
   CONFIG.C_TX_REFCLK_SEL {0} \
   CONFIG.C_Tx_Protocol {HDMI} \
   CONFIG.C_Txrefclk_Rdy_Invert {true} \
   CONFIG.Transceiver_Width {2} \
 ] $vid_phy_controller

  # Create interface connections
  connect_bd_intf_net -intf_net intf_net_bdry_in_DRU_CLK_IN [get_bd_intf_pins DRU_CLK_IN] [get_bd_intf_pins gt_refclk_buf/CLK_IN_D]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_tx_ss_LINK_DATA0_OUT [get_bd_intf_pins vid_phy_tx_axi4s_ch0] [get_bd_intf_pins vid_phy_controller/vid_phy_tx_axi4s_ch0]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_tx_ss_LINK_DATA1_OUT [get_bd_intf_pins vid_phy_tx_axi4s_ch1] [get_bd_intf_pins vid_phy_controller/vid_phy_tx_axi4s_ch1]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_tx_ss_LINK_DATA2_OUT [get_bd_intf_pins vid_phy_tx_axi4s_ch2] [get_bd_intf_pins vid_phy_controller/vid_phy_tx_axi4s_ch2]
  connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_rx_axi4s_ch0 [get_bd_intf_pins vid_phy_rx_axi4s_ch0] [get_bd_intf_pins vid_phy_controller/vid_phy_rx_axi4s_ch0]
  connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_rx_axi4s_ch1 [get_bd_intf_pins vid_phy_rx_axi4s_ch1] [get_bd_intf_pins vid_phy_controller/vid_phy_rx_axi4s_ch1]
  connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_rx_axi4s_ch2 [get_bd_intf_pins vid_phy_rx_axi4s_ch2] [get_bd_intf_pins vid_phy_controller/vid_phy_rx_axi4s_ch2]
  connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_status_sb_rx [get_bd_intf_pins vid_phy_status_sb_rx] [get_bd_intf_pins vid_phy_controller/vid_phy_status_sb_rx]
  connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_status_sb_tx [get_bd_intf_pins vid_phy_status_sb_tx] [get_bd_intf_pins vid_phy_controller/vid_phy_status_sb_tx]
  connect_bd_intf_net -intf_net intf_net_zynq_us_ss_0_M00_AXI [get_bd_intf_pins vid_phy_axi4lite] [get_bd_intf_pins vid_phy_controller/vid_phy_axi4lite]

  # Create port connections
  connect_bd_net -net net_bdry_in_HDMI_RX_CLK_N_IN [get_bd_pins HDMI_RX_CLK_N_IN] [get_bd_pins vid_phy_controller/mgtrefclk1_pad_n_in]
  connect_bd_net -net net_bdry_in_HDMI_RX_CLK_P_IN [get_bd_pins HDMI_RX_CLK_P_IN] [get_bd_pins vid_phy_controller/mgtrefclk1_pad_p_in]
  connect_bd_net -net net_bdry_in_HDMI_RX_DAT_N_IN [get_bd_pins HDMI_RX_DAT_N_IN] [get_bd_pins vid_phy_controller/phy_rxn_in]
  connect_bd_net -net net_bdry_in_HDMI_RX_DAT_P_IN [get_bd_pins HDMI_RX_DAT_P_IN] [get_bd_pins vid_phy_controller/phy_rxp_in]
  connect_bd_net -net net_bdry_in_IDT_8T49N241_LOL_IN [get_bd_pins IDT_8T49N241_LOL_IN] [get_bd_pins vid_phy_controller/tx_refclk_rdy]
  connect_bd_net -net net_bdry_in_TX_REFCLK_N_IN [get_bd_pins TX_REFCLK_N_IN] [get_bd_pins vid_phy_controller/mgtrefclk0_pad_n_in]
  connect_bd_net -net net_bdry_in_TX_REFCLK_P_IN [get_bd_pins TX_REFCLK_P_IN] [get_bd_pins vid_phy_controller/mgtrefclk0_pad_p_in]
  connect_bd_net -net net_dru_ibufds_gt_odiv2_BUFG_GT_O [get_bd_pins dru_ibufds_gt_odiv2/BUFG_GT_O] [get_bd_pins vid_phy_controller/gtnorthrefclk1_odiv2_in]
  connect_bd_net -net net_gt_refclk_buf_IBUF_DS_ODIV2 [get_bd_pins dru_ibufds_gt_odiv2/BUFG_GT_I] [get_bd_pins gt_refclk_buf/IBUF_DS_ODIV2]
  connect_bd_net -net net_gt_refclk_buf_IBUF_OUT [get_bd_pins gt_refclk_buf/IBUF_OUT] [get_bd_pins vid_phy_controller/gtnorthrefclk1_in]
  connect_bd_net -net net_vcc_const0_dout [get_bd_pins dru_ibufds_gt_odiv2/BUFG_GT_CE] [get_bd_pins vcc_const0/dout]
  connect_bd_net -net net_vcc_const_dout [get_bd_pins TX_EN_OUT] [get_bd_pins vid_phy_controller/vid_phy_rx_axi4s_aresetn] [get_bd_pins vid_phy_controller/vid_phy_tx_axi4s_aresetn]
  connect_bd_net -net net_vid_phy_controller_irq [get_bd_pins irq2] [get_bd_pins vid_phy_controller/irq]
  connect_bd_net -net net_vid_phy_controller_phy_txn_out [get_bd_pins HDMI_TX_DAT_N_OUT] [get_bd_pins vid_phy_controller/phy_txn_out]
  connect_bd_net -net net_vid_phy_controller_phy_txp_out [get_bd_pins HDMI_TX_DAT_P_OUT] [get_bd_pins vid_phy_controller/phy_txp_out]
  connect_bd_net -net net_vid_phy_controller_rx_tmds_clk_n [get_bd_pins RX_REFCLK_N_OUT] [get_bd_pins vid_phy_controller/rx_tmds_clk_n]
  connect_bd_net -net net_vid_phy_controller_rx_tmds_clk_p [get_bd_pins RX_REFCLK_P_OUT] [get_bd_pins vid_phy_controller/rx_tmds_clk_p]
  connect_bd_net -net net_vid_phy_controller_rx_video_clk [get_bd_pins rx_video_clk] [get_bd_pins vid_phy_controller/rx_video_clk]
  connect_bd_net -net net_vid_phy_controller_rxoutclk [get_bd_pins vid_phy_rx_axi4s_aclk] [get_bd_pins vid_phy_controller/rxoutclk] [get_bd_pins vid_phy_controller/vid_phy_rx_axi4s_aclk]
  connect_bd_net -net net_vid_phy_controller_tx_tmds_clk_n [get_bd_pins HDMI_TX_CLK_N_OUT] [get_bd_pins vid_phy_controller/tx_tmds_clk_n]
  connect_bd_net -net net_vid_phy_controller_tx_tmds_clk_p [get_bd_pins HDMI_TX_CLK_P_OUT] [get_bd_pins vid_phy_controller/tx_tmds_clk_p]
  connect_bd_net -net net_vid_phy_controller_tx_video_clk [get_bd_pins tx_video_clk] [get_bd_pins vid_phy_controller/tx_video_clk]
  connect_bd_net -net net_vid_phy_controller_txoutclk [get_bd_pins vid_phy_tx_axi4s_aclk] [get_bd_pins vid_phy_controller/txoutclk] [get_bd_pins vid_phy_controller/vid_phy_tx_axi4s_aclk]
  connect_bd_net -net net_zynq_us_ss_0_peripheral_aresetn [get_bd_pins s_axi_cpu_aresetn] [get_bd_pins vid_phy_controller/vid_phy_axi4lite_aresetn] [get_bd_pins vid_phy_controller/vid_phy_sb_aresetn]
  connect_bd_net -net net_zynq_us_ss_0_s_axi_aclk [get_bd_pins s_axi_cpu_aclk] [get_bd_pins vid_phy_controller/drpclk] [get_bd_pins vid_phy_controller/vid_phy_axi4lite_aclk] [get_bd_pins vid_phy_controller/vid_phy_sb_aclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hdmi_out
proc create_hier_cell_hdmi_out { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_hdmi_out() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 LINK_DATA0_OUT
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 LINK_DATA1_OUT
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 LINK_DATA2_OUT
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 SB_STATUS_IN
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_CPU_IN
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 TX_DDC_OUT
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_filter
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_flow
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_overlay
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_webcam
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_AXILiteS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_AXILiteS1
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_AXILiteS2
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_CTRL
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_CTRL1
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis_video2

  # Create pins
  create_bd_pin -dir I TX_HPD_IN
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I acr_valid
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I fid
  create_bd_pin -dir O -type intr irq1
  create_bd_pin -dir I -type clk link_clk
  create_bd_pin -dir I -type clk s_axi_cpu_aclk
  create_bd_pin -dir I -type rst s_axi_cpu_aresetn
  create_bd_pin -dir I -type clk s_axis_audio_aclk
  create_bd_pin -dir I -type rst s_axis_audio_aresetn
  create_bd_pin -dir I -type clk video_clk

  # Create instance: frontend, and set properties
  set frontend [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_hdmi_tx_ss:3.1 frontend ]
  set_property -dict [ list \
   CONFIG.C_ADDR_WIDTH {13} \
   CONFIG.C_ADD_MARK_DBG {false} \
   CONFIG.C_EXDES_AXILITE_FREQ {100} \
   CONFIG.C_EXDES_NIDRU {true} \
   CONFIG.C_EXDES_RX_PLL_SELECTION {0} \
   CONFIG.C_EXDES_TOPOLOGY {0} \
   CONFIG.C_EXDES_TX_PLL_SELECTION {6} \
   CONFIG.C_HDMI_FAST_SWITCH {true} \
   CONFIG.C_HDMI_VERSION {3} \
   CONFIG.C_HPD_INVERT {false} \
   CONFIG.C_HYSTERESIS_LEVEL {12} \
   CONFIG.C_INCLUDE_HDCP_1_4 {false} \
   CONFIG.C_INCLUDE_HDCP_2_2 {false} \
   CONFIG.C_INCLUDE_LOW_RESO_VID {false} \
   CONFIG.C_INCLUDE_YUV420_SUP {false} \
   CONFIG.C_INPUT_PIXELS_PER_CLOCK {2} \
   CONFIG.C_MAX_BITS_PER_COMPONENT {8} \
   CONFIG.C_VALIDATION_ENABLE {false} \
   CONFIG.C_VIDEO_MASK_ENABLE {1} \
   CONFIG.C_VID_INTERFACE {0} \
 ] $frontend

  # Create instance: logo_output_0, and set properties
  set logo_output_0 [ create_bd_cell -type ip -vlnv xilinx.com:hls:logo_output:1.0 logo_output_0 ]

  # Create instance: v_mix_0, and set properties
  set v_mix_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_mix:3.0 v_mix_0 ]
  set_property -dict [ list \
   CONFIG.AXIMM_ADDR_WIDTH {32} \
   CONFIG.AXIMM_DATA_WIDTH {128} \
   CONFIG.C_M_AXI_MM_VIDEO1_DATA_WIDTH {128} \
   CONFIG.C_M_AXI_MM_VIDEO2_DATA_WIDTH {128} \
   CONFIG.C_M_AXI_MM_VIDEO3_DATA_WIDTH {128} \
   CONFIG.C_M_AXI_MM_VIDEO4_DATA_WIDTH {128} \
   CONFIG.C_M_AXI_MM_VIDEO5_DATA_WIDTH {128} \
   CONFIG.C_M_AXI_MM_VIDEO6_DATA_WIDTH {128} \
   CONFIG.C_M_AXI_MM_VIDEO7_DATA_WIDTH {128} \
   CONFIG.C_M_AXI_MM_VIDEO8_DATA_WIDTH {128} \
   CONFIG.LAYER1_ALPHA {true} \
   CONFIG.LAYER1_INTF_TYPE {0} \
   CONFIG.LAYER1_UPSAMPLE {true} \
   CONFIG.LAYER1_VIDEO_FORMAT {28} \
   CONFIG.LAYER2_ALPHA {true} \
   CONFIG.LAYER2_INTF_TYPE {1} \
   CONFIG.LAYER2_UPSAMPLE {true} \
   CONFIG.LAYER2_VIDEO_FORMAT {2} \
   CONFIG.LAYER3_ALPHA {true} \
   CONFIG.LAYER3_INTF_TYPE {0} \
   CONFIG.LAYER3_UPSAMPLE {true} \
   CONFIG.LAYER3_VIDEO_FORMAT {10} \
   CONFIG.LAYER4_ALPHA {true} \
   CONFIG.LAYER4_INTF_TYPE {0} \
   CONFIG.LAYER4_UPSAMPLE {true} \
   CONFIG.LAYER4_VIDEO_FORMAT {10} \
   CONFIG.LAYER5_ALPHA {true} \
   CONFIG.LAYER5_UPSAMPLE {true} \
   CONFIG.LAYER5_VIDEO_FORMAT {13} \
   CONFIG.LAYER6_ALPHA {true} \
   CONFIG.LAYER6_INTF_TYPE {1} \
   CONFIG.LAYER6_MAX_WIDTH {256} \
   CONFIG.LAYER6_UPSAMPLE {true} \
   CONFIG.LAYER6_VIDEO_FORMAT {5} \
   CONFIG.LOGO_LAYER {false} \
   CONFIG.LOGO_PIXEL_ALPHA {true} \
   CONFIG.LOGO_TRANSPARENCY_COLOR {false} \
   CONFIG.MAX_LOGO_COLS {256} \
   CONFIG.MAX_LOGO_ROWS {256} \
   CONFIG.NR_LAYERS {7} \
   CONFIG.SAMPLES_PER_CLOCK {2} \
   CONFIG.USE_URAM {1} \
 ] $v_mix_0

  # Create instance: v_tpg_0, and set properties
  set v_tpg_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_tpg:7.0 v_tpg_0 ]
  set_property -dict [ list \
   CONFIG.SAMPLES_PER_CLOCK {2} \
 ] $v_tpg_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_axi_CTRL] [get_bd_intf_pins v_mix_0/s_axi_CTRL]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins m_axi_flow] [get_bd_intf_pins v_mix_0/m_axi_mm_video4]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins m_axi_filter] [get_bd_intf_pins v_mix_0/m_axi_mm_video3]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins s_axis_video2] [get_bd_intf_pins v_mix_0/s_axis_video2]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins s_axi_CTRL1] [get_bd_intf_pins v_tpg_0/s_axi_CTRL]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins s_axi_AXILiteS2] [get_bd_intf_pins logo_output_0/s_axi_AXILiteS]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_tx_ss_DDC_OUT [get_bd_intf_pins TX_DDC_OUT] [get_bd_intf_pins frontend/DDC_OUT]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_tx_ss_LINK_DATA0_OUT [get_bd_intf_pins LINK_DATA0_OUT] [get_bd_intf_pins frontend/LINK_DATA0_OUT]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_tx_ss_LINK_DATA1_OUT [get_bd_intf_pins LINK_DATA1_OUT] [get_bd_intf_pins frontend/LINK_DATA1_OUT]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_tx_ss_LINK_DATA2_OUT [get_bd_intf_pins LINK_DATA2_OUT] [get_bd_intf_pins frontend/LINK_DATA2_OUT]
  connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_status_sb_tx [get_bd_intf_pins SB_STATUS_IN] [get_bd_intf_pins frontend/SB_STATUS_IN]
  connect_bd_intf_net -intf_net intf_net_zynq_us_ss_0_M02_AXI [get_bd_intf_pins S_AXI_CPU_IN] [get_bd_intf_pins frontend/S_AXI_CPU_IN]
  connect_bd_intf_net -intf_net logo_output_0_out_stream [get_bd_intf_pins logo_output_0/out_stream] [get_bd_intf_pins v_mix_0/s_axis_video6]
  connect_bd_intf_net -intf_net m_axi_overlay_conn [get_bd_intf_pins m_axi_overlay] [get_bd_intf_pins v_mix_0/m_axi_mm_video5]
  connect_bd_intf_net -intf_net v_mix_0_m_axi_mm_video1 [get_bd_intf_pins m_axi_webcam] [get_bd_intf_pins v_mix_0/m_axi_mm_video1]
  connect_bd_intf_net -intf_net v_mix_0_m_axis_video [get_bd_intf_pins frontend/VIDEO_IN] [get_bd_intf_pins v_mix_0/m_axis_video]
  connect_bd_intf_net -intf_net v_tpg_0_m_axis_video [get_bd_intf_pins v_mix_0/s_axis_video] [get_bd_intf_pins v_tpg_0/m_axis_video]

  # Create port connections
  connect_bd_net -net acr_valid_1 [get_bd_pins acr_valid] [get_bd_pins frontend/acr_valid]
  connect_bd_net -net net_bdry_in_TX_HPD_IN [get_bd_pins TX_HPD_IN] [get_bd_pins frontend/hpd]
  connect_bd_net -net net_v_hdmi_rx_ss_fid [get_bd_pins fid] [get_bd_pins frontend/fid]
  connect_bd_net -net net_v_hdmi_tx_ss_irq [get_bd_pins irq1] [get_bd_pins frontend/irq]
  connect_bd_net -net net_v_hdmi_tx_ss_locked [get_bd_pins frontend/locked]
  connect_bd_net -net net_vid_phy_controller_tx_video_clk [get_bd_pins video_clk] [get_bd_pins frontend/video_clk]
  connect_bd_net -net net_vid_phy_controller_txoutclk [get_bd_pins link_clk] [get_bd_pins frontend/link_clk]
  connect_bd_net -net net_zynq_us_ss_0_clk_out2 [get_bd_pins aclk] [get_bd_pins frontend/s_axis_video_aclk] [get_bd_pins logo_output_0/ap_clk] [get_bd_pins v_mix_0/ap_clk] [get_bd_pins v_tpg_0/ap_clk]
  connect_bd_net -net net_zynq_us_ss_0_dcm_locked [get_bd_pins aresetn] [get_bd_pins frontend/s_axis_video_aresetn] [get_bd_pins logo_output_0/ap_rst_n] [get_bd_pins v_mix_0/ap_rst_n] [get_bd_pins v_tpg_0/ap_rst_n]
  connect_bd_net -net net_zynq_us_ss_0_peripheral_aresetn [get_bd_pins s_axi_cpu_aresetn] [get_bd_pins frontend/s_axi_cpu_aresetn]
  connect_bd_net -net net_zynq_us_ss_0_s_axi_aclk [get_bd_pins s_axi_cpu_aclk] [get_bd_pins frontend/s_axi_cpu_aclk]
  connect_bd_net -net s_axis_audio_aclk_1 [get_bd_pins s_axis_audio_aclk] [get_bd_pins frontend/s_axis_audio_aclk]
  connect_bd_net -net s_axis_audio_aresetn_1 [get_bd_pins s_axis_audio_aresetn] [get_bd_pins frontend/s_axis_audio_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hdmi_in
proc create_hier_cell_hdmi_in { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_hdmi_in() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 LINK_DATA0_IN
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 LINK_DATA1_IN
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 LINK_DATA2_IN
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 RX_DDC_OUT
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 SB_STATUS_IN
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_CPU_IN
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_AXILiteS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_AXILiteS1
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 stream_out_64

  # Create pins
  create_bd_pin -dir I RX_DET_IN
  create_bd_pin -dir O RX_HPD_OUT
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir O fid
  create_bd_pin -dir O -type intr irq
  create_bd_pin -dir I -type clk link_clk
  create_bd_pin -dir I -type clk s_axi_cpu_aclk
  create_bd_pin -dir I -type rst s_axi_cpu_aresetn
  create_bd_pin -dir I -type clk s_axis_audio_aclk
  create_bd_pin -dir I -type rst s_axis_audio_aresetn
  create_bd_pin -dir I -type clk video_clk

  # Create instance: color_convert, and set properties
  set color_convert [ create_bd_cell -type ip -vlnv xilinx.com:hls:color_convert_2:1.0 color_convert ]

  # Create instance: frontend, and set properties
  set frontend [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_hdmi_rx_ss:3.1 frontend ]
  set_property -dict [ list \
   CONFIG.C_ADDR_WIDTH {10} \
   CONFIG.C_ADD_MARK_DBG {false} \
   CONFIG.C_CD_INVERT {true} \
   CONFIG.C_EDID_RAM_SIZE {256} \
   CONFIG.C_HDMI_FAST_SWITCH {true} \
   CONFIG.C_HDMI_VERSION {3} \
   CONFIG.C_HPD_INVERT {false} \
   CONFIG.C_INCLUDE_HDCP_1_4 {false} \
   CONFIG.C_INCLUDE_HDCP_2_2 {false} \
   CONFIG.C_INCLUDE_LOW_RESO_VID {false} \
   CONFIG.C_INCLUDE_YUV420_SUP {false} \
   CONFIG.C_INPUT_PIXELS_PER_CLOCK {2} \
   CONFIG.C_MAX_BITS_PER_COMPONENT {8} \
   CONFIG.C_VALIDATION_ENABLE {false} \
   CONFIG.C_VID_INTERFACE {0} \
 ] $frontend

  # Create instance: pixel_pack, and set properties
  set pixel_pack [ create_bd_cell -type ip -vlnv xilinx.com:hls:pixel_pack_2:1.0 pixel_pack ]

  # Create instance: pixel_reorder, and set properties
  set pixel_reorder [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 pixel_reorder ]
  set_property -dict [ list \
   CONFIG.M_TDATA_NUM_BYTES {6} \
   CONFIG.S_TDATA_NUM_BYTES {6} \
   CONFIG.TDATA_REMAP {tdata[47:40],tdata[31:24],tdata[39:32],tdata[23:16],tdata[7:0],tdata[15:8]} \
 ] $pixel_reorder

  # Create instance: rx_video_axis_reg_slice, and set properties
  set rx_video_axis_reg_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 rx_video_axis_reg_slice ]

  # Create interface connections
  connect_bd_intf_net -intf_net axi_interconnect_M08_AXI [get_bd_intf_pins s_axi_AXILiteS] [get_bd_intf_pins color_convert/s_axi_AXILiteS]
  connect_bd_intf_net -intf_net axi_interconnect_M09_AXI [get_bd_intf_pins s_axi_AXILiteS1] [get_bd_intf_pins pixel_pack/s_axi_AXILiteS]
  connect_bd_intf_net -intf_net color_convert_1_stream_out_48 [get_bd_intf_pins color_convert/stream_out_48] [get_bd_intf_pins pixel_pack/stream_in_48]
  connect_bd_intf_net -intf_net frontend_VIDEO_OUT [get_bd_intf_pins frontend/VIDEO_OUT] [get_bd_intf_pins pixel_reorder/S_AXIS]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_rx_ss_DDC_OUT [get_bd_intf_pins RX_DDC_OUT] [get_bd_intf_pins frontend/DDC_OUT]
  connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_rx_axi4s_ch0 [get_bd_intf_pins LINK_DATA0_IN] [get_bd_intf_pins frontend/LINK_DATA0_IN]
  connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_rx_axi4s_ch1 [get_bd_intf_pins LINK_DATA1_IN] [get_bd_intf_pins frontend/LINK_DATA1_IN]
  connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_rx_axi4s_ch2 [get_bd_intf_pins LINK_DATA2_IN] [get_bd_intf_pins frontend/LINK_DATA2_IN]
  connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_status_sb_rx [get_bd_intf_pins SB_STATUS_IN] [get_bd_intf_pins frontend/SB_STATUS_IN]
  connect_bd_intf_net -intf_net intf_net_zynq_us_ss_0_M01_AXI [get_bd_intf_pins S_AXI_CPU_IN] [get_bd_intf_pins frontend/S_AXI_CPU_IN]
  connect_bd_intf_net -intf_net pixel_pack_0_stream_out_64 [get_bd_intf_pins stream_out_64] [get_bd_intf_pins pixel_pack/stream_out_64]
  connect_bd_intf_net -intf_net pixel_reorder_M_AXIS [get_bd_intf_pins pixel_reorder/M_AXIS] [get_bd_intf_pins rx_video_axis_reg_slice/S_AXIS]
  connect_bd_intf_net -intf_net rx_video_axis_reg_slice_M_AXIS [get_bd_intf_pins color_convert/stream_in_48] [get_bd_intf_pins rx_video_axis_reg_slice/M_AXIS]

  # Create port connections
  connect_bd_net -net net_bdry_in_RX_DET_IN [get_bd_pins RX_DET_IN] [get_bd_pins frontend/cable_detect]
  connect_bd_net -net net_v_hdmi_rx_ss_fid [get_bd_pins fid] [get_bd_pins frontend/fid]
  connect_bd_net -net net_v_hdmi_rx_ss_hpd [get_bd_pins RX_HPD_OUT] [get_bd_pins frontend/hpd]
  connect_bd_net -net net_v_hdmi_rx_ss_irq [get_bd_pins irq] [get_bd_pins frontend/irq]
  connect_bd_net -net net_vid_phy_controller_rx_video_clk [get_bd_pins video_clk] [get_bd_pins frontend/video_clk]
  connect_bd_net -net net_vid_phy_controller_rxoutclk [get_bd_pins link_clk] [get_bd_pins frontend/link_clk]
  connect_bd_net -net net_zynq_us_ss_0_clk_out2 [get_bd_pins aclk] [get_bd_pins color_convert/ap_clk] [get_bd_pins color_convert/control] [get_bd_pins frontend/s_axis_video_aclk] [get_bd_pins pixel_pack/ap_clk] [get_bd_pins pixel_pack/control] [get_bd_pins pixel_reorder/aclk] [get_bd_pins rx_video_axis_reg_slice/aclk]
  connect_bd_net -net net_zynq_us_ss_0_dcm_locked [get_bd_pins aresetn] [get_bd_pins color_convert/ap_rst_n] [get_bd_pins color_convert/ap_rst_n_control] [get_bd_pins frontend/s_axis_video_aresetn] [get_bd_pins pixel_pack/ap_rst_n] [get_bd_pins pixel_pack/ap_rst_n_control] [get_bd_pins pixel_reorder/aresetn] [get_bd_pins rx_video_axis_reg_slice/aresetn]
  connect_bd_net -net net_zynq_us_ss_0_peripheral_aresetn [get_bd_pins s_axi_cpu_aresetn] [get_bd_pins frontend/s_axi_cpu_aresetn]
  connect_bd_net -net net_zynq_us_ss_0_s_axi_aclk [get_bd_pins s_axi_cpu_aclk] [get_bd_pins frontend/s_axi_cpu_aclk]
  connect_bd_net -net s_axis_audio_aclk_1 [get_bd_pins s_axis_audio_aclk] [get_bd_pins frontend/s_axis_audio_aclk]
  connect_bd_net -net s_axis_audio_aresetn_1 [get_bd_pins s_axis_audio_aresetn] [get_bd_pins frontend/s_axis_audio_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: lmb
proc create_hier_cell_lmb_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_lmb_1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 BRAM_PORTB
  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 DLMB
  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 ILMB

  # Create pins
  create_bd_pin -dir I -type clk LMB_Clk
  create_bd_pin -dir I -from 0 -to 0 -type rst SYS_Rst

  # Create instance: dlmb_v10, and set properties
  set dlmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 dlmb_v10 ]

  # Create instance: ilmb_v10, and set properties
  set ilmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 ilmb_v10 ]

  # Create instance: lmb_bram, and set properties
  set lmb_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 lmb_bram ]
  set_property -dict [ list \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.use_bram_block {BRAM_Controller} \
 ] $lmb_bram

  # Create instance: lmb_bram_if_cntlr, and set properties
  set lmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 lmb_bram_if_cntlr ]
  set_property -dict [ list \
   CONFIG.C_ECC {0} \
   CONFIG.C_NUM_LMB {2} \
 ] $lmb_bram_if_cntlr

  # Create interface connections
  connect_bd_intf_net -intf_net Conn [get_bd_intf_pins dlmb_v10/LMB_Sl_0] [get_bd_intf_pins lmb_bram_if_cntlr/SLMB1]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins BRAM_PORTB] [get_bd_intf_pins lmb_bram/BRAM_PORTB]
  connect_bd_intf_net -intf_net lmb_bram_if_cntlr_BRAM_PORT [get_bd_intf_pins lmb_bram/BRAM_PORTA] [get_bd_intf_pins lmb_bram_if_cntlr/BRAM_PORT]
  connect_bd_intf_net -intf_net microblaze_0_dlmb [get_bd_intf_pins DLMB] [get_bd_intf_pins dlmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_ilmb [get_bd_intf_pins ILMB] [get_bd_intf_pins ilmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_bus [get_bd_intf_pins ilmb_v10/LMB_Sl_0] [get_bd_intf_pins lmb_bram_if_cntlr/SLMB]

  # Create port connections
  connect_bd_net -net SYS_Rst_1 [get_bd_pins SYS_Rst] [get_bd_pins dlmb_v10/SYS_Rst] [get_bd_pins ilmb_v10/SYS_Rst] [get_bd_pins lmb_bram_if_cntlr/LMB_Rst]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins LMB_Clk] [get_bd_pins dlmb_v10/LMB_Clk] [get_bd_pins ilmb_v10/LMB_Clk] [get_bd_pins lmb_bram_if_cntlr/LMB_Clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: lmb
proc create_hier_cell_lmb { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_lmb() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 BRAM_PORTB
  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 DLMB
  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 ILMB

  # Create pins
  create_bd_pin -dir I -type clk LMB_Clk
  create_bd_pin -dir I -from 0 -to 0 -type rst SYS_Rst

  # Create instance: dlmb_v10, and set properties
  set dlmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 dlmb_v10 ]

  # Create instance: ilmb_v10, and set properties
  set ilmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 ilmb_v10 ]

  # Create instance: lmb_bram, and set properties
  set lmb_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 lmb_bram ]
  set_property -dict [ list \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.use_bram_block {BRAM_Controller} \
 ] $lmb_bram

  # Create instance: lmb_bram_if_cntlr, and set properties
  set lmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 lmb_bram_if_cntlr ]
  set_property -dict [ list \
   CONFIG.C_ECC {0} \
   CONFIG.C_NUM_LMB {2} \
 ] $lmb_bram_if_cntlr

  # Create interface connections
  connect_bd_intf_net -intf_net Conn [get_bd_intf_pins dlmb_v10/LMB_Sl_0] [get_bd_intf_pins lmb_bram_if_cntlr/SLMB1]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins BRAM_PORTB] [get_bd_intf_pins lmb_bram/BRAM_PORTB]
  connect_bd_intf_net -intf_net lmb_bram_if_cntlr_BRAM_PORT [get_bd_intf_pins lmb_bram/BRAM_PORTA] [get_bd_intf_pins lmb_bram_if_cntlr/BRAM_PORT]
  connect_bd_intf_net -intf_net microblaze_0_dlmb [get_bd_intf_pins DLMB] [get_bd_intf_pins dlmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_ilmb [get_bd_intf_pins ILMB] [get_bd_intf_pins ilmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_bus [get_bd_intf_pins ilmb_v10/LMB_Sl_0] [get_bd_intf_pins lmb_bram_if_cntlr/SLMB]

  # Create port connections
  connect_bd_net -net SYS_Rst_1 [get_bd_pins SYS_Rst] [get_bd_pins dlmb_v10/SYS_Rst] [get_bd_pins ilmb_v10/SYS_Rst] [get_bd_pins lmb_bram_if_cntlr/LMB_Rst]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins LMB_Clk] [get_bd_pins dlmb_v10/LMB_Clk] [get_bd_pins ilmb_v10/LMB_Clk] [get_bd_pins lmb_bram_if_cntlr/LMB_Clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: video
proc create_hier_cell_video { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_video() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 DRU_CLK_IN
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 RX_DDC_OUT
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_CPU_IN
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_CPU_IN1
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 TX_DDC_OUT
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_filter
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_flow
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_hdmi_rx
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_hdmi_tx
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_overlay
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_webcam
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_AXILiteS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_AXILiteS1
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_AXILiteS2
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_AXILiteS3
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_AXILiteS4
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_CTRL
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_CTRL1
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 vid_phy_axi4lite

  # Create pins
  create_bd_pin -dir I -type clk HDMI_RX_CLK_N_IN
  create_bd_pin -dir I -type clk HDMI_RX_CLK_P_IN
  create_bd_pin -dir I -from 2 -to 0 HDMI_RX_DAT_N_IN
  create_bd_pin -dir I -from 2 -to 0 HDMI_RX_DAT_P_IN
  create_bd_pin -dir O -type clk HDMI_TX_CLK_N_OUT
  create_bd_pin -dir O -type clk HDMI_TX_CLK_P_OUT
  create_bd_pin -dir O -from 2 -to 0 HDMI_TX_DAT_N_OUT
  create_bd_pin -dir O -from 2 -to 0 HDMI_TX_DAT_P_OUT
  create_bd_pin -dir I IDT_8T49N241_LOL_IN
  create_bd_pin -dir I RX_DET_IN
  create_bd_pin -dir O RX_HPD_OUT
  create_bd_pin -dir O -type clk RX_REFCLK_N_OUT
  create_bd_pin -dir O -type clk RX_REFCLK_P_OUT
  create_bd_pin -dir I -type rst TX_EN_OUT
  create_bd_pin -dir I TX_HPD_IN
  create_bd_pin -dir I -type clk TX_REFCLK_N_IN
  create_bd_pin -dir I -type clk TX_REFCLK_P_IN
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir O -type intr irq
  create_bd_pin -dir O -type intr irq1
  create_bd_pin -dir O -type intr irq2
  create_bd_pin -dir O -type intr mm2s_introut
  create_bd_pin -dir O -type intr s2mm_introut
  create_bd_pin -dir I -type clk s_axi_cpu_aclk
  create_bd_pin -dir I -type rst s_axi_cpu_aresetn

  # Create instance: axi_vdma, and set properties
  set axi_vdma [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.3 axi_vdma ]
  set_property -dict [ list \
   CONFIG.c_m_axi_mm2s_data_width {128} \
   CONFIG.c_m_axi_s2mm_data_width {128} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_mm2s_linebuffer_depth {512} \
   CONFIG.c_mm2s_max_burst_length {256} \
   CONFIG.c_num_fstores {4} \
   CONFIG.c_s2mm_linebuffer_depth {4096} \
   CONFIG.c_s2mm_max_burst_length {256} \
 ] $axi_vdma

  # Create instance: axis_subset_converter_0, and set properties
  set axis_subset_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_subset_converter_0 ]
  set_property -dict [ list \
   CONFIG.TDATA_REMAP {tdata[23:16],tdata[31:24],tdata[7:0],tdata[15:8]} \
 ] $axis_subset_converter_0

  # Create instance: const_gnd, and set properties
  set const_gnd [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_gnd ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $const_gnd

  # Create instance: hdmi_in
  create_hier_cell_hdmi_in $hier_obj hdmi_in

  # Create instance: hdmi_out
  create_hier_cell_hdmi_out $hier_obj hdmi_out

  # Create instance: phy
  create_hier_cell_phy $hier_obj phy

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_axi_CTRL] [get_bd_intf_pins hdmi_out/s_axi_CTRL]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins s_axi_AXILiteS4] [get_bd_intf_pins hdmi_out/s_axi_AXILiteS2]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins m_axi_webcam] [get_bd_intf_pins hdmi_out/m_axi_webcam]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins m_axi_overlay] [get_bd_intf_pins hdmi_out/m_axi_overlay]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins s_axi_CTRL1] [get_bd_intf_pins hdmi_out/s_axi_CTRL1]
  connect_bd_intf_net -intf_net Conn8 [get_bd_intf_pins m_axi_flow] [get_bd_intf_pins hdmi_out/m_axi_flow]
  connect_bd_intf_net -intf_net Conn9 [get_bd_intf_pins m_axi_filter] [get_bd_intf_pins hdmi_out/m_axi_filter]
  connect_bd_intf_net -intf_net axi_interconnect_M07_AXI [get_bd_intf_pins s_axi_AXILiteS] [get_bd_intf_pins hdmi_out/s_axi_AXILiteS]
  connect_bd_intf_net -intf_net axi_interconnect_M08_AXI [get_bd_intf_pins s_axi_AXILiteS1] [get_bd_intf_pins hdmi_in/s_axi_AXILiteS]
  connect_bd_intf_net -intf_net axi_interconnect_M09_AXI [get_bd_intf_pins s_axi_AXILiteS2] [get_bd_intf_pins hdmi_in/s_axi_AXILiteS1]
  connect_bd_intf_net -intf_net axi_interconnect_M10_AXI [get_bd_intf_pins s_axi_AXILiteS3] [get_bd_intf_pins hdmi_out/s_axi_AXILiteS1]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXI_MM2S [get_bd_intf_pins m_axi_hdmi_tx] [get_bd_intf_pins axi_vdma/M_AXI_MM2S]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXI_S2MM [get_bd_intf_pins m_axi_hdmi_rx] [get_bd_intf_pins axi_vdma/M_AXI_S2MM]
  connect_bd_intf_net -intf_net axi_vdma_M_AXIS_MM2S [get_bd_intf_pins axi_vdma/M_AXIS_MM2S] [get_bd_intf_pins axis_subset_converter_0/S_AXIS]
  connect_bd_intf_net -intf_net axis_subset_converter_0_M_AXIS [get_bd_intf_pins axis_subset_converter_0/M_AXIS] [get_bd_intf_pins hdmi_out/s_axis_video2]
  connect_bd_intf_net -intf_net intf_net_bdry_in_DRU_CLK_IN [get_bd_intf_pins DRU_CLK_IN] [get_bd_intf_pins phy/DRU_CLK_IN]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_rx_ss_DDC_OUT [get_bd_intf_pins RX_DDC_OUT] [get_bd_intf_pins hdmi_in/RX_DDC_OUT]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_tx_ss_DDC_OUT [get_bd_intf_pins TX_DDC_OUT] [get_bd_intf_pins hdmi_out/TX_DDC_OUT]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_tx_ss_LINK_DATA0_OUT [get_bd_intf_pins hdmi_out/LINK_DATA0_OUT] [get_bd_intf_pins phy/vid_phy_tx_axi4s_ch0]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_tx_ss_LINK_DATA1_OUT [get_bd_intf_pins hdmi_out/LINK_DATA1_OUT] [get_bd_intf_pins phy/vid_phy_tx_axi4s_ch1]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_tx_ss_LINK_DATA2_OUT [get_bd_intf_pins hdmi_out/LINK_DATA2_OUT] [get_bd_intf_pins phy/vid_phy_tx_axi4s_ch2]
  connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_rx_axi4s_ch0 [get_bd_intf_pins hdmi_in/LINK_DATA0_IN] [get_bd_intf_pins phy/vid_phy_rx_axi4s_ch0]
  connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_rx_axi4s_ch1 [get_bd_intf_pins hdmi_in/LINK_DATA1_IN] [get_bd_intf_pins phy/vid_phy_rx_axi4s_ch1]
  connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_rx_axi4s_ch2 [get_bd_intf_pins hdmi_in/LINK_DATA2_IN] [get_bd_intf_pins phy/vid_phy_rx_axi4s_ch2]
  connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_status_sb_rx [get_bd_intf_pins hdmi_in/SB_STATUS_IN] [get_bd_intf_pins phy/vid_phy_status_sb_rx]
  connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_status_sb_tx [get_bd_intf_pins hdmi_out/SB_STATUS_IN] [get_bd_intf_pins phy/vid_phy_status_sb_tx]
  connect_bd_intf_net -intf_net intf_net_zynq_us_ss_0_M00_AXI [get_bd_intf_pins vid_phy_axi4lite] [get_bd_intf_pins phy/vid_phy_axi4lite]
  connect_bd_intf_net -intf_net intf_net_zynq_us_ss_0_M01_AXI [get_bd_intf_pins S_AXI_CPU_IN] [get_bd_intf_pins hdmi_in/S_AXI_CPU_IN]
  connect_bd_intf_net -intf_net intf_net_zynq_us_ss_0_M02_AXI [get_bd_intf_pins S_AXI_CPU_IN1] [get_bd_intf_pins hdmi_out/S_AXI_CPU_IN]
  connect_bd_intf_net -intf_net pixel_pack_0_stream_out_64 [get_bd_intf_pins axi_vdma/S_AXIS_S2MM] [get_bd_intf_pins hdmi_in/stream_out_64]
  connect_bd_intf_net -intf_net zynq_us_ss_0_M03_AXI [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins axi_vdma/S_AXI_LITE]

  # Create port connections
  connect_bd_net -net axi_vdma_0_mm2s_introut [get_bd_pins mm2s_introut] [get_bd_pins axi_vdma/mm2s_introut]
  connect_bd_net -net axi_vdma_0_s2mm_introut [get_bd_pins s2mm_introut] [get_bd_pins axi_vdma/s2mm_introut]
  connect_bd_net -net const_gnd_dout [get_bd_pins const_gnd/dout] [get_bd_pins hdmi_in/s_axis_audio_aclk] [get_bd_pins hdmi_in/s_axis_audio_aresetn] [get_bd_pins hdmi_out/acr_valid] [get_bd_pins hdmi_out/s_axis_audio_aclk] [get_bd_pins hdmi_out/s_axis_audio_aresetn]
  connect_bd_net -net net_bdry_in_HDMI_RX_CLK_N_IN [get_bd_pins HDMI_RX_CLK_N_IN] [get_bd_pins phy/HDMI_RX_CLK_N_IN]
  connect_bd_net -net net_bdry_in_HDMI_RX_CLK_P_IN [get_bd_pins HDMI_RX_CLK_P_IN] [get_bd_pins phy/HDMI_RX_CLK_P_IN]
  connect_bd_net -net net_bdry_in_HDMI_RX_DAT_N_IN [get_bd_pins HDMI_RX_DAT_N_IN] [get_bd_pins phy/HDMI_RX_DAT_N_IN]
  connect_bd_net -net net_bdry_in_HDMI_RX_DAT_P_IN [get_bd_pins HDMI_RX_DAT_P_IN] [get_bd_pins phy/HDMI_RX_DAT_P_IN]
  connect_bd_net -net net_bdry_in_IDT_8T49N241_LOL_IN [get_bd_pins IDT_8T49N241_LOL_IN] [get_bd_pins phy/IDT_8T49N241_LOL_IN]
  connect_bd_net -net net_bdry_in_RX_DET_IN [get_bd_pins RX_DET_IN] [get_bd_pins hdmi_in/RX_DET_IN]
  connect_bd_net -net net_bdry_in_TX_HPD_IN [get_bd_pins TX_HPD_IN] [get_bd_pins hdmi_out/TX_HPD_IN]
  connect_bd_net -net net_bdry_in_TX_REFCLK_N_IN [get_bd_pins TX_REFCLK_N_IN] [get_bd_pins phy/TX_REFCLK_N_IN]
  connect_bd_net -net net_bdry_in_TX_REFCLK_P_IN [get_bd_pins TX_REFCLK_P_IN] [get_bd_pins phy/TX_REFCLK_P_IN]
  connect_bd_net -net net_v_hdmi_rx_ss_hpd [get_bd_pins RX_HPD_OUT] [get_bd_pins hdmi_in/RX_HPD_OUT]
  connect_bd_net -net net_v_hdmi_rx_ss_irq [get_bd_pins irq] [get_bd_pins hdmi_in/irq]
  connect_bd_net -net net_v_hdmi_tx_ss_irq [get_bd_pins irq1] [get_bd_pins hdmi_out/irq1]
  connect_bd_net -net net_vcc_const_dout [get_bd_pins TX_EN_OUT] [get_bd_pins phy/TX_EN_OUT]
  connect_bd_net -net net_vid_phy_controller_irq [get_bd_pins irq2] [get_bd_pins phy/irq2]
  connect_bd_net -net net_vid_phy_controller_phy_txn_out [get_bd_pins HDMI_TX_DAT_N_OUT] [get_bd_pins phy/HDMI_TX_DAT_N_OUT]
  connect_bd_net -net net_vid_phy_controller_phy_txp_out [get_bd_pins HDMI_TX_DAT_P_OUT] [get_bd_pins phy/HDMI_TX_DAT_P_OUT]
  connect_bd_net -net net_vid_phy_controller_rx_tmds_clk_n [get_bd_pins RX_REFCLK_N_OUT] [get_bd_pins phy/RX_REFCLK_N_OUT]
  connect_bd_net -net net_vid_phy_controller_rx_tmds_clk_p [get_bd_pins RX_REFCLK_P_OUT] [get_bd_pins phy/RX_REFCLK_P_OUT]
  connect_bd_net -net net_vid_phy_controller_rx_video_clk [get_bd_pins hdmi_in/video_clk] [get_bd_pins phy/rx_video_clk]
  connect_bd_net -net net_vid_phy_controller_rxoutclk [get_bd_pins hdmi_in/link_clk] [get_bd_pins phy/vid_phy_rx_axi4s_aclk]
  connect_bd_net -net net_vid_phy_controller_tx_tmds_clk_n [get_bd_pins HDMI_TX_CLK_N_OUT] [get_bd_pins phy/HDMI_TX_CLK_N_OUT]
  connect_bd_net -net net_vid_phy_controller_tx_tmds_clk_p [get_bd_pins HDMI_TX_CLK_P_OUT] [get_bd_pins phy/HDMI_TX_CLK_P_OUT]
  connect_bd_net -net net_vid_phy_controller_tx_video_clk [get_bd_pins hdmi_out/video_clk] [get_bd_pins phy/tx_video_clk]
  connect_bd_net -net net_vid_phy_controller_txoutclk [get_bd_pins hdmi_out/link_clk] [get_bd_pins phy/vid_phy_tx_axi4s_aclk]
  connect_bd_net -net net_zynq_us_ss_0_clk_out2 [get_bd_pins aclk] [get_bd_pins axi_vdma/m_axi_mm2s_aclk] [get_bd_pins axi_vdma/m_axi_s2mm_aclk] [get_bd_pins axi_vdma/m_axis_mm2s_aclk] [get_bd_pins axi_vdma/s_axis_s2mm_aclk] [get_bd_pins axis_subset_converter_0/aclk] [get_bd_pins hdmi_in/aclk] [get_bd_pins hdmi_out/aclk]
  connect_bd_net -net net_zynq_us_ss_0_dcm_locked [get_bd_pins aresetn] [get_bd_pins axis_subset_converter_0/aresetn] [get_bd_pins hdmi_in/aresetn] [get_bd_pins hdmi_out/aresetn]
  connect_bd_net -net net_zynq_us_ss_0_peripheral_aresetn [get_bd_pins s_axi_cpu_aresetn] [get_bd_pins axi_vdma/axi_resetn] [get_bd_pins hdmi_in/s_axi_cpu_aresetn] [get_bd_pins hdmi_out/s_axi_cpu_aresetn] [get_bd_pins phy/s_axi_cpu_aresetn]
  connect_bd_net -net net_zynq_us_ss_0_s_axi_aclk [get_bd_pins s_axi_cpu_aclk] [get_bd_pins axi_vdma/s_axi_lite_aclk] [get_bd_pins hdmi_in/s_axi_cpu_aclk] [get_bd_pins hdmi_out/s_axi_cpu_aclk] [get_bd_pins phy/s_axi_cpu_aclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: iop_pmod1
proc create_hier_cell_iop_pmod1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_iop_pmod1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mbdebug_rtl:3.0 DEBUG
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  # Create pins
  create_bd_pin -dir I -from 0 -to 0 -type rst aux_reset_in
  create_bd_pin -dir I -type clk clk_100M
  create_bd_pin -dir I -from 7 -to 0 data_i
  create_bd_pin -dir O -from 7 -to 0 data_o
  create_bd_pin -dir I -from 0 -to 0 intr_ack
  create_bd_pin -dir O -from 0 -to 0 intr_req
  create_bd_pin -dir I -type rst mb_debug_sys_rst
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn
  create_bd_pin -dir I -from 0 -to 0 -type rst s_axi_aresetn
  create_bd_pin -dir O -from 7 -to 0 tri_o

  # Create instance: dff_en_reset_vector_0, and set properties
  set dff_en_reset_vector_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:dff_en_reset_vector:1.0 dff_en_reset_vector_0 ]
  set_property -dict [ list \
   CONFIG.SIZE {1} \
 ] $dff_en_reset_vector_0

  # Create instance: gpio, and set properties
  set gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS_2 {0} \
   CONFIG.C_GPIO2_WIDTH {32} \
   CONFIG.C_GPIO_WIDTH {8} \
   CONFIG.C_IS_DUAL {0} \
 ] $gpio

  # Create instance: iic, and set properties
  set iic [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 iic ]

  # Create instance: intc, and set properties
  set intc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 intc ]

  # Create instance: intr, and set properties
  set intr [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 intr ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {1} \
 ] $intr

  # Create instance: intr_concat, and set properties
  set intr_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 intr_concat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {3} \
 ] $intr_concat

  # Create instance: io_switch, and set properties
  set io_switch [ create_bd_cell -type ip -vlnv xilinx.com:user:io_switch:1.1 io_switch ]
  set_property -dict [ list \
   CONFIG.C_INTERFACE_TYPE {1} \
   CONFIG.C_IO_SWITCH_WIDTH {8} \
   CONFIG.C_NUM_PWMS {1} \
   CONFIG.C_NUM_TIMERS {1} \
   CONFIG.I2C0_Enable {true} \
   CONFIG.PWM_Enable {true} \
   CONFIG.SPI0_Enable {true} \
   CONFIG.Timer_Enable {true} \
 ] $io_switch

  # Create instance: lmb
  create_hier_cell_lmb_1 $hier_obj lmb

  # Create instance: logic_1, and set properties
  set logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 logic_1 ]

  # Create instance: mb, and set properties
  set mb [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:10.0 mb ]
  set_property -dict [ list \
   CONFIG.C_DEBUG_ENABLED {1} \
   CONFIG.C_D_AXI {1} \
   CONFIG.C_D_LMB {1} \
   CONFIG.C_I_LMB {1} \
 ] $mb

  # Create instance: mb_bram_ctrl, and set properties
  set mb_bram_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 mb_bram_ctrl ]
  set_property -dict [ list \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $mb_bram_ctrl

  # Create instance: microblaze_0_axi_periph, and set properties
  set microblaze_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 microblaze_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.M00_HAS_REGSLICE {1} \
   CONFIG.M01_HAS_REGSLICE {1} \
   CONFIG.M02_HAS_REGSLICE {1} \
   CONFIG.M03_HAS_REGSLICE {1} \
   CONFIG.M04_HAS_REGSLICE {1} \
   CONFIG.M05_HAS_REGSLICE {1} \
   CONFIG.M06_HAS_REGSLICE {1} \
   CONFIG.M07_HAS_REGSLICE {1} \
   CONFIG.NUM_MI {8} \
   CONFIG.S00_HAS_REGSLICE {1} \
 ] $microblaze_0_axi_periph

  # Create instance: rst_clk_wiz_1_100M, and set properties
  set rst_clk_wiz_1_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_1_100M ]
  set_property -dict [ list \
   CONFIG.C_AUX_RESET_HIGH {1} \
 ] $rst_clk_wiz_1_100M

  # Create instance: spi, and set properties
  set spi [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 spi ]
  set_property -dict [ list \
   CONFIG.C_USE_STARTUP {0} \
 ] $spi

  # Create instance: timer, and set properties
  set timer [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 timer ]

  # Create interface connections
  connect_bd_intf_net -intf_net BRAM_PORTB_1 [get_bd_intf_pins lmb/BRAM_PORTB] [get_bd_intf_pins mb_bram_ctrl/BRAM_PORTA]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins M_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M07_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI] [get_bd_intf_pins mb_bram_ctrl/S_AXI]
  connect_bd_intf_net -intf_net gpio_GPIO [get_bd_intf_pins gpio/GPIO] [get_bd_intf_pins io_switch/gpio]
  connect_bd_intf_net -intf_net iic_IIC [get_bd_intf_pins iic/IIC] [get_bd_intf_pins io_switch/iic0]
  connect_bd_intf_net -intf_net mb1_intc_interrupt [get_bd_intf_pins intc/interrupt] [get_bd_intf_pins mb/INTERRUPT]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DP [get_bd_intf_pins mb/M_AXI_DP] [get_bd_intf_pins microblaze_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M00_AXI [get_bd_intf_pins microblaze_0_axi_periph/M00_AXI] [get_bd_intf_pins spi/AXI_LITE]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M01_AXI [get_bd_intf_pins iic/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M02_AXI [get_bd_intf_pins io_switch/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M03_AXI [get_bd_intf_pins gpio/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M04_AXI [get_bd_intf_pins microblaze_0_axi_periph/M04_AXI] [get_bd_intf_pins timer/S_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M05_AXI [get_bd_intf_pins intc/s_axi] [get_bd_intf_pins microblaze_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M06_AXI [get_bd_intf_pins intr/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net microblaze_0_debug [get_bd_intf_pins DEBUG] [get_bd_intf_pins mb/DEBUG]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_1 [get_bd_intf_pins lmb/DLMB] [get_bd_intf_pins mb/DLMB]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_1 [get_bd_intf_pins lmb/ILMB] [get_bd_intf_pins mb/ILMB]
  connect_bd_intf_net -intf_net spi_SPI_0 [get_bd_intf_pins io_switch/spi0] [get_bd_intf_pins spi/SPI_0]

  # Create port connections
  connect_bd_net -net dff_en_reset_vector_0_q [get_bd_pins intr_req] [get_bd_pins dff_en_reset_vector_0/q]
  connect_bd_net -net io_data_i_0_1 [get_bd_pins data_i] [get_bd_pins io_switch/io_data_i]
  connect_bd_net -net io_switch_0_timer_i [get_bd_pins io_switch/timer_i] [get_bd_pins timer/capturetrig0]
  connect_bd_net -net io_switch_io_data_o [get_bd_pins data_o] [get_bd_pins io_switch/io_data_o]
  connect_bd_net -net io_switch_io_tri_o [get_bd_pins tri_o] [get_bd_pins io_switch/io_tri_o]
  connect_bd_net -net iop_pmoda_intr_ack_1 [get_bd_pins intr_ack] [get_bd_pins dff_en_reset_vector_0/reset]
  connect_bd_net -net iop_pmoda_intr_gpio_io_o [get_bd_pins dff_en_reset_vector_0/en] [get_bd_pins intr/gpio_io_o]
  connect_bd_net -net logic_1_dout1 [get_bd_pins dff_en_reset_vector_0/d] [get_bd_pins logic_1/dout] [get_bd_pins rst_clk_wiz_1_100M/ext_reset_in]
  connect_bd_net -net mb1_iic_iic2intc_irpt [get_bd_pins iic/iic2intc_irpt] [get_bd_pins intr_concat/In0]
  connect_bd_net -net mb1_interrupt_concat_dout [get_bd_pins intc/intr] [get_bd_pins intr_concat/dout]
  connect_bd_net -net mb1_spi_ip2intc_irpt [get_bd_pins intr_concat/In1] [get_bd_pins spi/ip2intc_irpt]
  connect_bd_net -net mb1_timer_generateout0 [get_bd_pins io_switch/timer_o] [get_bd_pins timer/generateout0]
  connect_bd_net -net mb1_timer_interrupt [get_bd_pins intr_concat/In2] [get_bd_pins timer/interrupt]
  connect_bd_net -net mb1_timer_pwm0 [get_bd_pins io_switch/pwm_o] [get_bd_pins timer/pwm0]
  connect_bd_net -net mb_1_reset_Dout [get_bd_pins aux_reset_in] [get_bd_pins rst_clk_wiz_1_100M/aux_reset_in]
  connect_bd_net -net mdm_1_debug_sys_rst [get_bd_pins mb_debug_sys_rst] [get_bd_pins rst_clk_wiz_1_100M/mb_debug_sys_rst]
  connect_bd_net -net ps7_0_FCLK_CLK0 [get_bd_pins clk_100M] [get_bd_pins dff_en_reset_vector_0/clk] [get_bd_pins gpio/s_axi_aclk] [get_bd_pins iic/s_axi_aclk] [get_bd_pins intc/s_axi_aclk] [get_bd_pins intr/s_axi_aclk] [get_bd_pins io_switch/s_axi_aclk] [get_bd_pins lmb/LMB_Clk] [get_bd_pins mb/Clk] [get_bd_pins mb_bram_ctrl/s_axi_aclk] [get_bd_pins microblaze_0_axi_periph/ACLK] [get_bd_pins microblaze_0_axi_periph/M00_ACLK] [get_bd_pins microblaze_0_axi_periph/M01_ACLK] [get_bd_pins microblaze_0_axi_periph/M02_ACLK] [get_bd_pins microblaze_0_axi_periph/M03_ACLK] [get_bd_pins microblaze_0_axi_periph/M04_ACLK] [get_bd_pins microblaze_0_axi_periph/M05_ACLK] [get_bd_pins microblaze_0_axi_periph/M06_ACLK] [get_bd_pins microblaze_0_axi_periph/M07_ACLK] [get_bd_pins microblaze_0_axi_periph/S00_ACLK] [get_bd_pins rst_clk_wiz_1_100M/slowest_sync_clk] [get_bd_pins spi/ext_spi_clk] [get_bd_pins spi/s_axi_aclk] [get_bd_pins timer/s_axi_aclk]
  connect_bd_net -net rst_clk_wiz_1_100M_bus_struct_reset [get_bd_pins lmb/SYS_Rst] [get_bd_pins rst_clk_wiz_1_100M/bus_struct_reset]
  connect_bd_net -net rst_clk_wiz_1_100M_interconnect_aresetn [get_bd_pins microblaze_0_axi_periph/ARESETN] [get_bd_pins rst_clk_wiz_1_100M/interconnect_aresetn]
  connect_bd_net -net rst_clk_wiz_1_100M_mb_reset [get_bd_pins mb/Reset] [get_bd_pins rst_clk_wiz_1_100M/mb_reset]
  connect_bd_net -net rst_clk_wiz_1_100M_peripheral_aresetn [get_bd_pins peripheral_aresetn] [get_bd_pins gpio/s_axi_aresetn] [get_bd_pins iic/s_axi_aresetn] [get_bd_pins intc/s_axi_aresetn] [get_bd_pins microblaze_0_axi_periph/M00_ARESETN] [get_bd_pins microblaze_0_axi_periph/M01_ARESETN] [get_bd_pins microblaze_0_axi_periph/M02_ARESETN] [get_bd_pins microblaze_0_axi_periph/M03_ARESETN] [get_bd_pins microblaze_0_axi_periph/M04_ARESETN] [get_bd_pins microblaze_0_axi_periph/M05_ARESETN] [get_bd_pins microblaze_0_axi_periph/M06_ARESETN] [get_bd_pins microblaze_0_axi_periph/M07_ARESETN] [get_bd_pins microblaze_0_axi_periph/S00_ARESETN] [get_bd_pins rst_clk_wiz_1_100M/peripheral_aresetn] [get_bd_pins spi/s_axi_aresetn] [get_bd_pins timer/s_axi_aresetn]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins intr/s_axi_aresetn] [get_bd_pins io_switch/s_axi_aresetn] [get_bd_pins mb_bram_ctrl/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: iop_pmod0
proc create_hier_cell_iop_pmod0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_iop_pmod0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mbdebug_rtl:3.0 DEBUG
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  # Create pins
  create_bd_pin -dir I -from 0 -to 0 -type rst aux_reset_in
  create_bd_pin -dir I -type clk clk_100M
  create_bd_pin -dir I -from 7 -to 0 data_i
  create_bd_pin -dir O -from 7 -to 0 data_o
  create_bd_pin -dir I -from 0 -to 0 intr_ack
  create_bd_pin -dir O -from 0 -to 0 intr_req
  create_bd_pin -dir I -type rst mb_debug_sys_rst
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn
  create_bd_pin -dir I -from 0 -to 0 -type rst s_axi_aresetn
  create_bd_pin -dir O -from 7 -to 0 tri_o

  # Create instance: dff_en_reset_vector_0, and set properties
  set dff_en_reset_vector_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:dff_en_reset_vector:1.0 dff_en_reset_vector_0 ]
  set_property -dict [ list \
   CONFIG.SIZE {1} \
 ] $dff_en_reset_vector_0

  # Create instance: gpio, and set properties
  set gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS_2 {0} \
   CONFIG.C_GPIO2_WIDTH {32} \
   CONFIG.C_GPIO_WIDTH {8} \
   CONFIG.C_IS_DUAL {0} \
 ] $gpio

  # Create instance: iic, and set properties
  set iic [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 iic ]

  # Create instance: intc, and set properties
  set intc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 intc ]

  # Create instance: intr, and set properties
  set intr [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 intr ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {1} \
 ] $intr

  # Create instance: intr_concat, and set properties
  set intr_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 intr_concat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {3} \
 ] $intr_concat

  # Create instance: io_switch, and set properties
  set io_switch [ create_bd_cell -type ip -vlnv xilinx.com:user:io_switch:1.1 io_switch ]
  set_property -dict [ list \
   CONFIG.C_INTERFACE_TYPE {1} \
   CONFIG.C_IO_SWITCH_WIDTH {8} \
   CONFIG.C_NUM_PWMS {1} \
   CONFIG.C_NUM_TIMERS {1} \
   CONFIG.I2C0_Enable {true} \
   CONFIG.PWM_Enable {true} \
   CONFIG.SPI0_Enable {true} \
   CONFIG.Timer_Enable {true} \
 ] $io_switch

  # Create instance: lmb
  create_hier_cell_lmb $hier_obj lmb

  # Create instance: logic_1, and set properties
  set logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 logic_1 ]

  # Create instance: mb, and set properties
  set mb [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:10.0 mb ]
  set_property -dict [ list \
   CONFIG.C_DEBUG_ENABLED {1} \
   CONFIG.C_D_AXI {1} \
   CONFIG.C_D_LMB {1} \
   CONFIG.C_I_LMB {1} \
 ] $mb

  # Create instance: mb_bram_ctrl, and set properties
  set mb_bram_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 mb_bram_ctrl ]
  set_property -dict [ list \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $mb_bram_ctrl

  # Create instance: microblaze_0_axi_periph, and set properties
  set microblaze_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 microblaze_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.M00_HAS_REGSLICE {1} \
   CONFIG.M01_HAS_REGSLICE {1} \
   CONFIG.M02_HAS_REGSLICE {1} \
   CONFIG.M03_HAS_REGSLICE {1} \
   CONFIG.M04_HAS_REGSLICE {1} \
   CONFIG.M05_HAS_REGSLICE {1} \
   CONFIG.M06_HAS_REGSLICE {1} \
   CONFIG.M07_HAS_REGSLICE {1} \
   CONFIG.NUM_MI {8} \
   CONFIG.S00_HAS_REGSLICE {1} \
 ] $microblaze_0_axi_periph

  # Create instance: rst_clk_wiz_1_100M, and set properties
  set rst_clk_wiz_1_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_1_100M ]
  set_property -dict [ list \
   CONFIG.C_AUX_RESET_HIGH {1} \
 ] $rst_clk_wiz_1_100M

  # Create instance: spi, and set properties
  set spi [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 spi ]
  set_property -dict [ list \
   CONFIG.C_USE_STARTUP {0} \
 ] $spi

  # Create instance: timer, and set properties
  set timer [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 timer ]

  # Create interface connections
  connect_bd_intf_net -intf_net BRAM_PORTB_1 [get_bd_intf_pins lmb/BRAM_PORTB] [get_bd_intf_pins mb_bram_ctrl/BRAM_PORTA]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins M_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M07_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI] [get_bd_intf_pins mb_bram_ctrl/S_AXI]
  connect_bd_intf_net -intf_net gpio_GPIO [get_bd_intf_pins gpio/GPIO] [get_bd_intf_pins io_switch/gpio]
  connect_bd_intf_net -intf_net iic_IIC [get_bd_intf_pins iic/IIC] [get_bd_intf_pins io_switch/iic0]
  connect_bd_intf_net -intf_net mb1_intc_interrupt [get_bd_intf_pins intc/interrupt] [get_bd_intf_pins mb/INTERRUPT]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DP [get_bd_intf_pins mb/M_AXI_DP] [get_bd_intf_pins microblaze_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M00_AXI [get_bd_intf_pins microblaze_0_axi_periph/M00_AXI] [get_bd_intf_pins spi/AXI_LITE]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M01_AXI [get_bd_intf_pins iic/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M02_AXI [get_bd_intf_pins io_switch/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M03_AXI [get_bd_intf_pins gpio/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M04_AXI [get_bd_intf_pins microblaze_0_axi_periph/M04_AXI] [get_bd_intf_pins timer/S_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M05_AXI [get_bd_intf_pins intc/s_axi] [get_bd_intf_pins microblaze_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M06_AXI [get_bd_intf_pins intr/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net microblaze_0_debug [get_bd_intf_pins DEBUG] [get_bd_intf_pins mb/DEBUG]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_1 [get_bd_intf_pins lmb/DLMB] [get_bd_intf_pins mb/DLMB]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_1 [get_bd_intf_pins lmb/ILMB] [get_bd_intf_pins mb/ILMB]
  connect_bd_intf_net -intf_net spi_SPI_0 [get_bd_intf_pins io_switch/spi0] [get_bd_intf_pins spi/SPI_0]

  # Create port connections
  connect_bd_net -net dff_en_reset_vector_0_q [get_bd_pins intr_req] [get_bd_pins dff_en_reset_vector_0/q]
  connect_bd_net -net io_data_i_0_1 [get_bd_pins data_i] [get_bd_pins io_switch/io_data_i]
  connect_bd_net -net io_switch_0_timer_i [get_bd_pins io_switch/timer_i] [get_bd_pins timer/capturetrig0]
  connect_bd_net -net io_switch_io_data_o [get_bd_pins data_o] [get_bd_pins io_switch/io_data_o]
  connect_bd_net -net io_switch_io_tri_o [get_bd_pins tri_o] [get_bd_pins io_switch/io_tri_o]
  connect_bd_net -net iop_pmoda_intr_ack_1 [get_bd_pins intr_ack] [get_bd_pins dff_en_reset_vector_0/reset]
  connect_bd_net -net iop_pmoda_intr_gpio_io_o [get_bd_pins dff_en_reset_vector_0/en] [get_bd_pins intr/gpio_io_o]
  connect_bd_net -net logic_1_dout1 [get_bd_pins dff_en_reset_vector_0/d] [get_bd_pins logic_1/dout] [get_bd_pins rst_clk_wiz_1_100M/ext_reset_in]
  connect_bd_net -net mb1_iic_iic2intc_irpt [get_bd_pins iic/iic2intc_irpt] [get_bd_pins intr_concat/In0]
  connect_bd_net -net mb1_interrupt_concat_dout [get_bd_pins intc/intr] [get_bd_pins intr_concat/dout]
  connect_bd_net -net mb1_spi_ip2intc_irpt [get_bd_pins intr_concat/In1] [get_bd_pins spi/ip2intc_irpt]
  connect_bd_net -net mb1_timer_generateout0 [get_bd_pins io_switch/timer_o] [get_bd_pins timer/generateout0]
  connect_bd_net -net mb1_timer_interrupt [get_bd_pins intr_concat/In2] [get_bd_pins timer/interrupt]
  connect_bd_net -net mb1_timer_pwm0 [get_bd_pins io_switch/pwm_o] [get_bd_pins timer/pwm0]
  connect_bd_net -net mb_1_reset_Dout [get_bd_pins aux_reset_in] [get_bd_pins rst_clk_wiz_1_100M/aux_reset_in]
  connect_bd_net -net mdm_1_debug_sys_rst [get_bd_pins mb_debug_sys_rst] [get_bd_pins rst_clk_wiz_1_100M/mb_debug_sys_rst]
  connect_bd_net -net ps7_0_FCLK_CLK0 [get_bd_pins clk_100M] [get_bd_pins dff_en_reset_vector_0/clk] [get_bd_pins gpio/s_axi_aclk] [get_bd_pins iic/s_axi_aclk] [get_bd_pins intc/s_axi_aclk] [get_bd_pins intr/s_axi_aclk] [get_bd_pins io_switch/s_axi_aclk] [get_bd_pins lmb/LMB_Clk] [get_bd_pins mb/Clk] [get_bd_pins mb_bram_ctrl/s_axi_aclk] [get_bd_pins microblaze_0_axi_periph/ACLK] [get_bd_pins microblaze_0_axi_periph/M00_ACLK] [get_bd_pins microblaze_0_axi_periph/M01_ACLK] [get_bd_pins microblaze_0_axi_periph/M02_ACLK] [get_bd_pins microblaze_0_axi_periph/M03_ACLK] [get_bd_pins microblaze_0_axi_periph/M04_ACLK] [get_bd_pins microblaze_0_axi_periph/M05_ACLK] [get_bd_pins microblaze_0_axi_periph/M06_ACLK] [get_bd_pins microblaze_0_axi_periph/M07_ACLK] [get_bd_pins microblaze_0_axi_periph/S00_ACLK] [get_bd_pins rst_clk_wiz_1_100M/slowest_sync_clk] [get_bd_pins spi/ext_spi_clk] [get_bd_pins spi/s_axi_aclk] [get_bd_pins timer/s_axi_aclk]
  connect_bd_net -net rst_clk_wiz_1_100M_bus_struct_reset [get_bd_pins lmb/SYS_Rst] [get_bd_pins rst_clk_wiz_1_100M/bus_struct_reset]
  connect_bd_net -net rst_clk_wiz_1_100M_interconnect_aresetn [get_bd_pins microblaze_0_axi_periph/ARESETN] [get_bd_pins rst_clk_wiz_1_100M/interconnect_aresetn]
  connect_bd_net -net rst_clk_wiz_1_100M_mb_reset [get_bd_pins mb/Reset] [get_bd_pins rst_clk_wiz_1_100M/mb_reset]
  connect_bd_net -net rst_clk_wiz_1_100M_peripheral_aresetn [get_bd_pins peripheral_aresetn] [get_bd_pins gpio/s_axi_aresetn] [get_bd_pins iic/s_axi_aresetn] [get_bd_pins intc/s_axi_aresetn] [get_bd_pins microblaze_0_axi_periph/M00_ARESETN] [get_bd_pins microblaze_0_axi_periph/M01_ARESETN] [get_bd_pins microblaze_0_axi_periph/M02_ARESETN] [get_bd_pins microblaze_0_axi_periph/M03_ARESETN] [get_bd_pins microblaze_0_axi_periph/M04_ARESETN] [get_bd_pins microblaze_0_axi_periph/M05_ARESETN] [get_bd_pins microblaze_0_axi_periph/M06_ARESETN] [get_bd_pins microblaze_0_axi_periph/M07_ARESETN] [get_bd_pins microblaze_0_axi_periph/S00_ARESETN] [get_bd_pins rst_clk_wiz_1_100M/peripheral_aresetn] [get_bd_pins spi/s_axi_aresetn] [get_bd_pins timer/s_axi_aresetn]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins intr/s_axi_aresetn] [get_bd_pins io_switch/s_axi_aresetn] [get_bd_pins mb_bram_ctrl/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DRU_CLK_IN [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 DRU_CLK_IN ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {156250000} \
   ] $DRU_CLK_IN
  set RX_DDC_OUT [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 RX_DDC_OUT ]
  set TX_DDC_OUT [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 TX_DDC_OUT ]
  set clk_125 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 clk_125 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
   ] $clk_125
  set dip_switch_4bits [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 dip_switch_4bits ]
  set fmch_iic [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 fmch_iic ]
  set led_4bits [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 led_4bits ]
  set push_button_4bits [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 push_button_4bits ]

  # Create ports
  set HDMI_RX_CLK_N_IN [ create_bd_port -dir I HDMI_RX_CLK_N_IN ]
  set HDMI_RX_CLK_P_IN [ create_bd_port -dir I HDMI_RX_CLK_P_IN ]
  set HDMI_RX_DAT_N_IN [ create_bd_port -dir I -from 2 -to 0 HDMI_RX_DAT_N_IN ]
  set HDMI_RX_DAT_P_IN [ create_bd_port -dir I -from 2 -to 0 HDMI_RX_DAT_P_IN ]
  set HDMI_RX_LS_OE [ create_bd_port -dir O -from 0 -to 0 HDMI_RX_LS_OE ]
  set HDMI_TX_CLK_N_OUT [ create_bd_port -dir O HDMI_TX_CLK_N_OUT ]
  set HDMI_TX_CLK_P_OUT [ create_bd_port -dir O HDMI_TX_CLK_P_OUT ]
  set HDMI_TX_DAT_N_OUT [ create_bd_port -dir O -from 2 -to 0 HDMI_TX_DAT_N_OUT ]
  set HDMI_TX_DAT_P_OUT [ create_bd_port -dir O -from 2 -to 0 HDMI_TX_DAT_P_OUT ]
  set IDT_8T49N241_LOL_IN [ create_bd_port -dir I IDT_8T49N241_LOL_IN ]
  set IDT_8T49N241_RST_OUT [ create_bd_port -dir O -from 0 -to 0 IDT_8T49N241_RST_OUT ]
  set RX_DET_IN [ create_bd_port -dir I RX_DET_IN ]
  set RX_HPD_OUT [ create_bd_port -dir O RX_HPD_OUT ]
  set RX_REFCLK_N_OUT [ create_bd_port -dir O RX_REFCLK_N_OUT ]
  set RX_REFCLK_P_OUT [ create_bd_port -dir O RX_REFCLK_P_OUT ]
  set TX_EN_OUT [ create_bd_port -dir O -from 0 -to 0 TX_EN_OUT ]
  set TX_HPD_IN [ create_bd_port -dir I TX_HPD_IN ]
  set TX_REFCLK_N_IN [ create_bd_port -dir I TX_REFCLK_N_IN ]
  set TX_REFCLK_P_IN [ create_bd_port -dir I TX_REFCLK_P_IN ]
  set pmod0 [ create_bd_port -dir IO -from 7 -to 0 pmod0 ]
  set pmod1 [ create_bd_port -dir IO -from 7 -to 0 pmod1 ]
  set reset [ create_bd_port -dir I -type rst reset ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $reset

  # Create instance: axi_intc_0, and set properties
  set axi_intc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc_0 ]
  set_property -dict [ list \
   CONFIG.C_IRQ_CONNECTION {1} \
 ] $axi_intc_0

  # Create instance: axi_interconnect, and set properties
  set axi_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect ]
  set_property -dict [ list \
   CONFIG.NUM_MI {24} \
 ] $axi_interconnect

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {2} \
 ] $axi_interconnect_0

  # Create instance: axi_mem_HP0, and set properties
  set axi_mem_HP0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_HP0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {2} \
 ] $axi_mem_HP0

  # Create instance: axi_mem_HP1, and set properties
  set axi_mem_HP1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_HP1 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {2} \
 ] $axi_mem_HP1

  # Create instance: axi_mem_HP2, and set properties
  set axi_mem_HP2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_HP2 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {2} \
 ] $axi_mem_HP2

  # Create instance: axi_mem_HP3, and set properties
  set axi_mem_HP3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_HP3 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {3} \
 ] $axi_mem_HP3

  # Create instance: axi_mem_HPC0, and set properties
  set axi_mem_HPC0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_HPC0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {1} \
 ] $axi_mem_HPC0

  # Create instance: axi_register_slice_0, and set properties
  set axi_register_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_0 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {31} \
 ] $axi_register_slice_0

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {80.0} \
   CONFIG.CLKOUT1_JITTER {219.012} \
   CONFIG.CLKOUT1_PHASE_ERROR {319.537} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {33.33} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {82.125} \
   CONFIG.MMCM_CLKIN1_PERIOD {8.000} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {38.500} \
   CONFIG.MMCM_DIVCLK_DIVIDE {8} \
   CONFIG.PRIM_IN_FREQ {125} \
   CONFIG.USE_RESET {false} \
 ] $clk_wiz_0

  # Create instance: filter_pipeline_0, and set properties
  set filter_pipeline_0 [ create_bd_cell -type ip -vlnv xilinx.com:hls:filter_pipeline:1.0 filter_pipeline_0 ]

  set_property -dict [ list \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
 ] [get_bd_intf_pins /filter_pipeline_0/s_axi_AXILiteS]

  # Create instance: fmch_axi_iic, and set properties
  set fmch_axi_iic [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 fmch_axi_iic ]
  set_property -dict [ list \
   CONFIG.C_SCL_INERTIAL_DELAY {10} \
   CONFIG.C_SDA_INERTIAL_DELAY {10} \
   CONFIG.IIC_BOARD_INTERFACE {Custom} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $fmch_axi_iic

  # Create instance: gpio_btns, and set properties
  set gpio_btns [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_btns ]
  set_property -dict [ list \
   CONFIG.C_INTERRUPT_PRESENT {1} \
   CONFIG.GPIO_BOARD_INTERFACE {push_button_4bits} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $gpio_btns

  # Create instance: gpio_leds, and set properties
  set gpio_leds [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_leds ]
  set_property -dict [ list \
   CONFIG.C_INTERRUPT_PRESENT {0} \
   CONFIG.GPIO_BOARD_INTERFACE {led_4bits} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $gpio_leds

  # Create instance: gpio_sws, and set properties
  set gpio_sws [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_sws ]
  set_property -dict [ list \
   CONFIG.C_INTERRUPT_PRESENT {1} \
   CONFIG.GPIO_BOARD_INTERFACE {dip_switch_4bits} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $gpio_sws

  # Create instance: iop_pmod0
  create_hier_cell_iop_pmod0 [current_bd_instance .] iop_pmod0

  # Create instance: iop_pmod1
  create_hier_cell_iop_pmod1 [current_bd_instance .] iop_pmod1

  # Create instance: mb_pmod0_intr_ack, and set properties
  set mb_pmod0_intr_ack [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 mb_pmod0_intr_ack ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {4} \
   CONFIG.DOUT_WIDTH {1} \
 ] $mb_pmod0_intr_ack

  # Create instance: mb_pmod0_reset, and set properties
  set mb_pmod0_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 mb_pmod0_reset ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {4} \
 ] $mb_pmod0_reset

  # Create instance: mb_pmod1_intr_ack, and set properties
  set mb_pmod1_intr_ack [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 mb_pmod1_intr_ack ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DIN_WIDTH {4} \
   CONFIG.DOUT_WIDTH {1} \
 ] $mb_pmod1_intr_ack

  # Create instance: mb_pmod1_reset, and set properties
  set mb_pmod1_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 mb_pmod1_reset ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {4} \
   CONFIG.DOUT_WIDTH {1} \
 ] $mb_pmod1_reset

  # Create instance: mdm_0, and set properties
  set mdm_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mdm:3.2 mdm_0 ]
  set_property -dict [ list \
   CONFIG.C_MB_DBG_PORTS {2} \
 ] $mdm_0

  # Create instance: optical_flow_0, and set properties
  set optical_flow_0 [ create_bd_cell -type ip -vlnv xilinx.com:hls:optical_flow:1.0 optical_flow_0 ]

  set_property -dict [ list \
   CONFIG.SUPPORTS_NARROW_BURST {0} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.MAX_BURST_LENGTH {1} \
 ] [get_bd_intf_pins /optical_flow_0/s_axi_AXILiteS]

  # Create instance: pmod0_buf, and set properties
  set pmod0_buf [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 pmod0_buf ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {IOBUF} \
   CONFIG.C_SIZE {8} \
 ] $pmod0_buf

  # Create instance: pmod1_buf, and set properties
  set pmod1_buf [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 pmod1_buf ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {IOBUF} \
   CONFIG.C_SIZE {8} \
 ] $pmod1_buf

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: reset_control, and set properties
  set reset_control [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 reset_control ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
 ] $reset_control

  # Create instance: rst_processor_1_100M, and set properties
  set rst_processor_1_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processor_1_100M ]
  set_property -dict [ list \
   CONFIG.RESET_BOARD_INTERFACE {reset} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $rst_processor_1_100M

  # Create instance: rst_processor_1_300M, and set properties
  set rst_processor_1_300M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processor_1_300M ]
  set_property -dict [ list \
   CONFIG.RESET_BOARD_INTERFACE {reset} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $rst_processor_1_300M

  # Create instance: shutdown_HP0_FPD, and set properties
  set shutdown_HP0_FPD [ create_bd_cell -type ip -vlnv xilinx.com:ip:pr_axi_shutdown_manager:1.0 shutdown_HP0_FPD ]
  set_property -dict [ list \
   CONFIG.CTRL_INTERFACE_TYPE {1} \
   CONFIG.DP_AXI_DATA_WIDTH {128} \
 ] $shutdown_HP0_FPD

  # Create instance: shutdown_HP2_FPD, and set properties
  set shutdown_HP2_FPD [ create_bd_cell -type ip -vlnv xilinx.com:ip:pr_axi_shutdown_manager:1.0 shutdown_HP2_FPD ]
  set_property -dict [ list \
   CONFIG.CTRL_INTERFACE_TYPE {1} \
   CONFIG.DP_AXI_DATA_WIDTH {128} \
 ] $shutdown_HP2_FPD

  # Create instance: shutdown_LPD, and set properties
  set shutdown_LPD [ create_bd_cell -type ip -vlnv xilinx.com:ip:pr_axi_shutdown_manager:1.0 shutdown_LPD ]
  set_property -dict [ list \
   CONFIG.CTRL_INTERFACE_TYPE {1} \
   CONFIG.DP_AXI_DATA_WIDTH {128} \
 ] $shutdown_LPD

  # Create instance: util_ds_buf_0, and set properties
  set util_ds_buf_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_0 ]

  # Create instance: vcc_const, and set properties
  set vcc_const [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 vcc_const ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {1} \
 ] $vcc_const

  # Create instance: video
  create_hier_cell_video [current_bd_instance .] video

  # Create instance: xlconcat0, and set properties
  set xlconcat0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {10} \
 ] $xlconcat0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {2} \
 ] $xlconcat_0

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_1

  # Create instance: zynq_us, and set properties
  set zynq_us [ create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.2 zynq_us ]
  set_property -dict [ list \
   CONFIG.PSU_BANK_0_IO_STANDARD {LVCMOS18} \
   CONFIG.PSU_BANK_1_IO_STANDARD {LVCMOS18} \
   CONFIG.PSU_BANK_2_IO_STANDARD {LVCMOS18} \
   CONFIG.PSU_DDR_RAM_HIGHADDR {0x7FFFFFFF} \
   CONFIG.PSU_DDR_RAM_HIGHADDR_OFFSET {0x00000002} \
   CONFIG.PSU_DDR_RAM_LOWADDR_OFFSET {0x80000000} \
   CONFIG.PSU_MIO_0_DIRECTION {out} \
   CONFIG.PSU_MIO_0_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_10_DIRECTION {inout} \
   CONFIG.PSU_MIO_11_DIRECTION {inout} \
   CONFIG.PSU_MIO_12_DIRECTION {inout} \
   CONFIG.PSU_MIO_13_DIRECTION {inout} \
   CONFIG.PSU_MIO_14_DIRECTION {inout} \
   CONFIG.PSU_MIO_15_DIRECTION {inout} \
   CONFIG.PSU_MIO_16_DIRECTION {inout} \
   CONFIG.PSU_MIO_17_DIRECTION {inout} \
   CONFIG.PSU_MIO_18_DIRECTION {in} \
   CONFIG.PSU_MIO_18_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_18_SLEW {slow} \
   CONFIG.PSU_MIO_19_DIRECTION {out} \
   CONFIG.PSU_MIO_19_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_1_DIRECTION {inout} \
   CONFIG.PSU_MIO_20_DIRECTION {out} \
   CONFIG.PSU_MIO_20_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_21_DIRECTION {in} \
   CONFIG.PSU_MIO_21_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_21_SLEW {slow} \
   CONFIG.PSU_MIO_22_DIRECTION {inout} \
   CONFIG.PSU_MIO_23_DIRECTION {inout} \
   CONFIG.PSU_MIO_24_DIRECTION {out} \
   CONFIG.PSU_MIO_24_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_25_DIRECTION {in} \
   CONFIG.PSU_MIO_25_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_25_SLEW {slow} \
   CONFIG.PSU_MIO_26_DIRECTION {inout} \
   CONFIG.PSU_MIO_27_DIRECTION {out} \
   CONFIG.PSU_MIO_27_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_28_DIRECTION {in} \
   CONFIG.PSU_MIO_28_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_28_SLEW {slow} \
   CONFIG.PSU_MIO_29_DIRECTION {out} \
   CONFIG.PSU_MIO_29_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_2_DIRECTION {inout} \
   CONFIG.PSU_MIO_30_DIRECTION {in} \
   CONFIG.PSU_MIO_30_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_30_SLEW {slow} \
   CONFIG.PSU_MIO_31_DIRECTION {inout} \
   CONFIG.PSU_MIO_32_DIRECTION {inout} \
   CONFIG.PSU_MIO_33_DIRECTION {inout} \
   CONFIG.PSU_MIO_34_DIRECTION {inout} \
   CONFIG.PSU_MIO_35_DIRECTION {inout} \
   CONFIG.PSU_MIO_36_DIRECTION {inout} \
   CONFIG.PSU_MIO_37_DIRECTION {inout} \
   CONFIG.PSU_MIO_38_DIRECTION {inout} \
   CONFIG.PSU_MIO_39_DIRECTION {inout} \
   CONFIG.PSU_MIO_3_DIRECTION {inout} \
   CONFIG.PSU_MIO_40_DIRECTION {inout} \
   CONFIG.PSU_MIO_41_DIRECTION {inout} \
   CONFIG.PSU_MIO_42_DIRECTION {inout} \
   CONFIG.PSU_MIO_43_DIRECTION {inout} \
   CONFIG.PSU_MIO_44_DIRECTION {inout} \
   CONFIG.PSU_MIO_45_DIRECTION {in} \
   CONFIG.PSU_MIO_45_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_45_SLEW {slow} \
   CONFIG.PSU_MIO_46_DIRECTION {inout} \
   CONFIG.PSU_MIO_47_DIRECTION {inout} \
   CONFIG.PSU_MIO_48_DIRECTION {inout} \
   CONFIG.PSU_MIO_49_DIRECTION {inout} \
   CONFIG.PSU_MIO_4_DIRECTION {inout} \
   CONFIG.PSU_MIO_50_DIRECTION {inout} \
   CONFIG.PSU_MIO_51_DIRECTION {out} \
   CONFIG.PSU_MIO_51_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_52_DIRECTION {in} \
   CONFIG.PSU_MIO_52_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_52_SLEW {slow} \
   CONFIG.PSU_MIO_53_DIRECTION {in} \
   CONFIG.PSU_MIO_53_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_53_SLEW {slow} \
   CONFIG.PSU_MIO_54_DIRECTION {inout} \
   CONFIG.PSU_MIO_55_DIRECTION {in} \
   CONFIG.PSU_MIO_55_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_55_SLEW {slow} \
   CONFIG.PSU_MIO_56_DIRECTION {inout} \
   CONFIG.PSU_MIO_57_DIRECTION {inout} \
   CONFIG.PSU_MIO_58_DIRECTION {out} \
   CONFIG.PSU_MIO_58_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_59_DIRECTION {inout} \
   CONFIG.PSU_MIO_5_DIRECTION {out} \
   CONFIG.PSU_MIO_5_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_60_DIRECTION {inout} \
   CONFIG.PSU_MIO_61_DIRECTION {inout} \
   CONFIG.PSU_MIO_62_DIRECTION {inout} \
   CONFIG.PSU_MIO_63_DIRECTION {inout} \
   CONFIG.PSU_MIO_64_DIRECTION {out} \
   CONFIG.PSU_MIO_64_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_65_DIRECTION {out} \
   CONFIG.PSU_MIO_65_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_66_DIRECTION {out} \
   CONFIG.PSU_MIO_66_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_67_DIRECTION {out} \
   CONFIG.PSU_MIO_67_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_68_DIRECTION {out} \
   CONFIG.PSU_MIO_68_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_69_DIRECTION {out} \
   CONFIG.PSU_MIO_69_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_6_DIRECTION {out} \
   CONFIG.PSU_MIO_6_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_70_DIRECTION {in} \
   CONFIG.PSU_MIO_70_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_70_SLEW {slow} \
   CONFIG.PSU_MIO_71_DIRECTION {in} \
   CONFIG.PSU_MIO_71_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_71_SLEW {slow} \
   CONFIG.PSU_MIO_72_DIRECTION {in} \
   CONFIG.PSU_MIO_72_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_72_SLEW {slow} \
   CONFIG.PSU_MIO_73_DIRECTION {in} \
   CONFIG.PSU_MIO_73_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_73_SLEW {slow} \
   CONFIG.PSU_MIO_74_DIRECTION {in} \
   CONFIG.PSU_MIO_74_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_74_SLEW {slow} \
   CONFIG.PSU_MIO_75_DIRECTION {in} \
   CONFIG.PSU_MIO_75_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_75_SLEW {slow} \
   CONFIG.PSU_MIO_76_DIRECTION {out} \
   CONFIG.PSU_MIO_76_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_77_DIRECTION {inout} \
   CONFIG.PSU_MIO_7_DIRECTION {inout} \
   CONFIG.PSU_MIO_7_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_8_DIRECTION {inout} \
   CONFIG.PSU_MIO_9_DIRECTION {inout} \
   CONFIG.PSU_MIO_TREE_PERIPHERALS {Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Feedback Clk#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#I2C 0#I2C 0#I2C 1#I2C 1#UART 0#UART 0#UART 1#UART 1#GPIO0 MIO#GPIO0 MIO#CAN 1#CAN 1#GPIO1 MIO#DPAUX#DPAUX#DPAUX#DPAUX#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#SD 1#SD 1#SD 1#SD 1#SD 1#SD 1#SD 1#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#MDIO 3#MDIO 3} \
   CONFIG.PSU_MIO_TREE_SIGNALS {sclk_out#miso_mo1#mo2#mo3#mosi_mi0#n_ss_out#clk_for_lpbk#gpio0[7]#gpio0[8]#gpio0[9]#gpio0[10]#gpio0[11]#gpio0[12]#gpio0[13]#scl_out#sda_out#scl_out#sda_out#rxd#txd#txd#rxd#gpio0[22]#gpio0[23]#phy_tx#phy_rx#gpio1[26]#dp_aux_data_out#dp_hot_plug_detect#dp_aux_data_oe#dp_aux_data_in#gpio1[31]#gpio1[32]#gpio1[33]#gpio1[34]#gpio1[35]#gpio1[36]#gpio1[37]#gpio1[38]#gpio1[39]#gpio1[40]#gpio1[41]#gpio1[42]#gpio1[43]#gpio1[44]#sdio1_cd_n#sdio1_data_out[0]#sdio1_data_out[1]#sdio1_data_out[2]#sdio1_data_out[3]#sdio1_cmd_out#sdio1_clk_out#ulpi_clk_in#ulpi_dir#ulpi_tx_data[2]#ulpi_nxt#ulpi_tx_data[0]#ulpi_tx_data[1]#ulpi_stp#ulpi_tx_data[3]#ulpi_tx_data[4]#ulpi_tx_data[5]#ulpi_tx_data[6]#ulpi_tx_data[7]#rgmii_tx_clk#rgmii_txd[0]#rgmii_txd[1]#rgmii_txd[2]#rgmii_txd[3]#rgmii_tx_ctl#rgmii_rx_clk#rgmii_rxd[0]#rgmii_rxd[1]#rgmii_rxd[2]#rgmii_rxd[3]#rgmii_rx_ctl#gem3_mdc#gem3_mdio_out} \
   CONFIG.PSU_SD1_INTERNAL_BUS_WIDTH {4} \
   CONFIG.PSU__ACT_DDR_FREQ_MHZ {1066.656006} \
   CONFIG.PSU__AFI0_COHERENCY {0} \
   CONFIG.PSU__AFI1_COHERENCY {0} \
   CONFIG.PSU__CAN1__GRP_CLK__ENABLE {0} \
   CONFIG.PSU__CAN1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__CAN1__PERIPHERAL__IO {MIO 24 .. 25} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__ACT_FREQMHZ {1199.988000} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__DIVISOR0 {1} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__FREQMHZ {1200} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__SRCSEL {APLL} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__FBDIV {72} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRF_APB__APLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRF_APB__APLL_TO_LPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__ACT_FREQMHZ {249.997500} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__ACT_FREQMHZ {249.997500} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__ACT_FREQMHZ {533.328000} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__FREQMHZ {1067} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__ACT_FREQMHZ {599.994000} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__FREQMHZ {600} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__SRCSEL {APLL} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__FBDIV {64} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRF_APB__DPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRF_APB__DPLL_TO_LPD_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__ACT_FREQMHZ {24.999750} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__DIVISOR0 {20} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRF_APB__DP_AUDIO__FRAC_ENABLED {0} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__ACT_FREQMHZ {26.315526} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__DIVISOR0 {19} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__ACT_FREQMHZ {299.997000} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__SRCSEL {VPLL} \
   CONFIG.PSU__CRF_APB__DP_VIDEO__FRAC_ENABLED {0} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__ACT_FREQMHZ {599.994000} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__FREQMHZ {600} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__SRCSEL {APLL} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__ACT_FREQMHZ {499.995000} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__DIVISOR0 {1} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__ACT_FREQMHZ {249.997500} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__ACT_FREQMHZ {99.999000} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__ACT_FREQMHZ {533.328000} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__FREQMHZ {533.33} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__FBDIV {90} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRF_APB__VPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRF_APB__VPLL_TO_LPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__ACT_FREQMHZ {499.995000} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__AFI6_REF_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__ACT_FREQMHZ {49.999500} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__DIVISOR0 {30} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__ACT_FREQMHZ {99.999000} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__ACT_FREQMHZ {499.995000} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__ACT_FREQMHZ {249.997500} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__DLL_REF_CTRL__ACT_FREQMHZ {1499.985000} \
   CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__ACT_FREQMHZ {124.998750} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__FREQMHZ {125} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__ACT_FREQMHZ {249.997500} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__ACT_FREQMHZ {99.999000} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__ACT_FREQMHZ {99.999000} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__FBDIV {90} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRL_APB__IOPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRL_APB__IOPLL_TO_FPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__ACT_FREQMHZ {249.997500} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__ACT_FREQMHZ {99.999000} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__ACT_FREQMHZ {499.995000} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__NAND_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__NAND_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__ACT_FREQMHZ {187.498125} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__DIVISOR0 {8} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__FREQMHZ {200} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__ACT_FREQMHZ {99.999000} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__ACT_FREQMHZ {299.997000} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__FREQMHZ {300} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__DIVISOR0 {4} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__DIVISOR0 {4} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__ACT_FREQMHZ {124.998750} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__FREQMHZ {125} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__FBDIV {90} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRL_APB__RPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRL_APB__RPLL_TO_FPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__DIVISOR0 {7} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__ACT_FREQMHZ {187.498125} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__DIVISOR0 {8} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__FREQMHZ {200} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__DIVISOR0 {7} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__DIVISOR0 {7} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__ACT_FREQMHZ {99.999000} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__ACT_FREQMHZ {99.999000} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__ACT_FREQMHZ {99.999000} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__ACT_FREQMHZ {249.997500} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__ACT_FREQMHZ {19.999800} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__DIVISOR0 {25} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__DIVISOR1 {3} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__FREQMHZ {20} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB3__ENABLE {1} \
   CONFIG.PSU__DDRC__ADDR_MIRROR {0} \
   CONFIG.PSU__DDRC__BANK_ADDR_COUNT {2} \
   CONFIG.PSU__DDRC__BG_ADDR_COUNT {1} \
   CONFIG.PSU__DDRC__BRC_MAPPING {ROW_BANK_COL} \
   CONFIG.PSU__DDRC__BUS_WIDTH {64 Bit} \
   CONFIG.PSU__DDRC__CL {15} \
   CONFIG.PSU__DDRC__CLOCK_STOP_EN {0} \
   CONFIG.PSU__DDRC__COL_ADDR_COUNT {10} \
   CONFIG.PSU__DDRC__COMPONENTS {Components} \
   CONFIG.PSU__DDRC__CWL {14} \
   CONFIG.PSU__DDRC__DDR4_ADDR_MAPPING {0} \
   CONFIG.PSU__DDRC__DDR4_CAL_MODE_ENABLE {0} \
   CONFIG.PSU__DDRC__DDR4_CRC_CONTROL {0} \
   CONFIG.PSU__DDRC__DDR4_T_REF_MODE {0} \
   CONFIG.PSU__DDRC__DDR4_T_REF_RANGE {Normal (0-85)} \
   CONFIG.PSU__DDRC__DEEP_PWR_DOWN_EN {0} \
   CONFIG.PSU__DDRC__DEVICE_CAPACITY {4096 MBits} \
   CONFIG.PSU__DDRC__DIMM_ADDR_MIRROR {0} \
   CONFIG.PSU__DDRC__DM_DBI {DM_NO_DBI} \
   CONFIG.PSU__DDRC__DQMAP_0_3 {0} \
   CONFIG.PSU__DDRC__DQMAP_12_15 {0} \
   CONFIG.PSU__DDRC__DQMAP_16_19 {0} \
   CONFIG.PSU__DDRC__DQMAP_20_23 {0} \
   CONFIG.PSU__DDRC__DQMAP_24_27 {0} \
   CONFIG.PSU__DDRC__DQMAP_28_31 {0} \
   CONFIG.PSU__DDRC__DQMAP_32_35 {0} \
   CONFIG.PSU__DDRC__DQMAP_36_39 {0} \
   CONFIG.PSU__DDRC__DQMAP_40_43 {0} \
   CONFIG.PSU__DDRC__DQMAP_44_47 {0} \
   CONFIG.PSU__DDRC__DQMAP_48_51 {0} \
   CONFIG.PSU__DDRC__DQMAP_4_7 {0} \
   CONFIG.PSU__DDRC__DQMAP_52_55 {0} \
   CONFIG.PSU__DDRC__DQMAP_56_59 {0} \
   CONFIG.PSU__DDRC__DQMAP_60_63 {0} \
   CONFIG.PSU__DDRC__DQMAP_64_67 {0} \
   CONFIG.PSU__DDRC__DQMAP_68_71 {0} \
   CONFIG.PSU__DDRC__DQMAP_8_11 {0} \
   CONFIG.PSU__DDRC__DRAM_WIDTH {16 Bits} \
   CONFIG.PSU__DDRC__ECC {Disabled} \
   CONFIG.PSU__DDRC__ENABLE_LP4_HAS_ECC_COMP {0} \
   CONFIG.PSU__DDRC__ENABLE_LP4_SLOWBOOT {0} \
   CONFIG.PSU__DDRC__FGRM {1X} \
   CONFIG.PSU__DDRC__LP_ASR {manual normal} \
   CONFIG.PSU__DDRC__MEMORY_TYPE {DDR 4} \
   CONFIG.PSU__DDRC__PARITY_ENABLE {0} \
   CONFIG.PSU__DDRC__PER_BANK_REFRESH {0} \
   CONFIG.PSU__DDRC__PHY_DBI_MODE {0} \
   CONFIG.PSU__DDRC__ROW_ADDR_COUNT {15} \
   CONFIG.PSU__DDRC__SB_TARGET {15-15-15} \
   CONFIG.PSU__DDRC__SELF_REF_ABORT {0} \
   CONFIG.PSU__DDRC__SPEED_BIN {DDR4_2133P} \
   CONFIG.PSU__DDRC__STATIC_RD_MODE {0} \
   CONFIG.PSU__DDRC__TRAIN_DATA_EYE {1} \
   CONFIG.PSU__DDRC__TRAIN_READ_GATE {1} \
   CONFIG.PSU__DDRC__TRAIN_WRITE_LEVEL {1} \
   CONFIG.PSU__DDRC__T_FAW {30.0} \
   CONFIG.PSU__DDRC__T_RAS_MIN {33} \
   CONFIG.PSU__DDRC__T_RC {47.06} \
   CONFIG.PSU__DDRC__T_RCD {15} \
   CONFIG.PSU__DDRC__T_RP {15} \
   CONFIG.PSU__DDRC__VENDOR_PART {OTHERS} \
   CONFIG.PSU__DDRC__VREF {1} \
   CONFIG.PSU__DDR_HIGH_ADDRESS_GUI_ENABLE {0} \
   CONFIG.PSU__DDR__INTERFACE__FREQMHZ {533.500} \
   CONFIG.PSU__DISPLAYPORT__LANE0__ENABLE {1} \
   CONFIG.PSU__DISPLAYPORT__LANE0__IO {GT Lane1} \
   CONFIG.PSU__DISPLAYPORT__LANE1__ENABLE {1} \
   CONFIG.PSU__DISPLAYPORT__LANE1__IO {GT Lane0} \
   CONFIG.PSU__DISPLAYPORT__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__DLL__ISUSED {1} \
   CONFIG.PSU__DPAUX__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__DPAUX__PERIPHERAL__IO {MIO 27 .. 30} \
   CONFIG.PSU__DP__LANE_SEL {Dual Lower} \
   CONFIG.PSU__DP__REF_CLK_FREQ {27} \
   CONFIG.PSU__DP__REF_CLK_SEL {Ref Clk3} \
   CONFIG.PSU__ENET3__FIFO__ENABLE {0} \
   CONFIG.PSU__ENET3__GRP_MDIO__ENABLE {1} \
   CONFIG.PSU__ENET3__GRP_MDIO__IO {MIO 76 .. 77} \
   CONFIG.PSU__ENET3__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__ENET3__PERIPHERAL__IO {MIO 64 .. 75} \
   CONFIG.PSU__ENET3__PTP__ENABLE {0} \
   CONFIG.PSU__ENET3__TSU__ENABLE {0} \
   CONFIG.PSU__FPDMASTERS_COHERENCY {0} \
   CONFIG.PSU__FPD_SLCR__WDT1__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__FPD_SLCR__WDT1__FREQMHZ {99.999001} \
   CONFIG.PSU__FPD_SLCR__WDT_CLK_SEL__SELECT {APB} \
   CONFIG.PSU__FPGA_PL0_ENABLE {1} \
   CONFIG.PSU__FPGA_PL1_ENABLE {1} \
   CONFIG.PSU__GEM3_COHERENCY {0} \
   CONFIG.PSU__GEM__TSU__ENABLE {0} \
   CONFIG.PSU__GPIO0_MIO__IO {MIO 0 .. 25} \
   CONFIG.PSU__GPIO0_MIO__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__GPIO1_MIO__IO {MIO 26 .. 51} \
   CONFIG.PSU__GPIO1_MIO__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__GPIO_EMIO_WIDTH {4} \
   CONFIG.PSU__GPIO_EMIO__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__GPIO_EMIO__PERIPHERAL__IO {4} \
   CONFIG.PSU__GT__LINK_SPEED {HBR} \
   CONFIG.PSU__GT__PRE_EMPH_LVL_4 {0} \
   CONFIG.PSU__GT__VLT_SWNG_LVL_4 {0} \
   CONFIG.PSU__I2C0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__I2C0__PERIPHERAL__IO {MIO 14 .. 15} \
   CONFIG.PSU__I2C1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__I2C1__PERIPHERAL__IO {MIO 16 .. 17} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC0_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC1_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC2_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC3_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__TTC0__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC0__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC1__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC1__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC2__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC2__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC3__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC3__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__WDT0__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__IOU_SLCR__WDT0__FREQMHZ {99.999001} \
   CONFIG.PSU__IOU_SLCR__WDT_CLK_SEL__SELECT {APB} \
   CONFIG.PSU__MAXIGP0__DATA_WIDTH {128} \
   CONFIG.PSU__MAXIGP1__DATA_WIDTH {128} \
   CONFIG.PSU__MAXIGP2__DATA_WIDTH {128} \
   CONFIG.PSU__OVERRIDE__BASIC_CLOCK {0} \
   CONFIG.PSU__PL_CLK0_BUF {TRUE} \
   CONFIG.PSU__PL_CLK1_BUF {TRUE} \
   CONFIG.PSU__PRESET_APPLIED {1} \
   CONFIG.PSU__PROTECTION__MASTERS {USB1:NonSecure;0|USB0:NonSecure;1|S_AXI_LPD:NA;1|S_AXI_HPC1_FPD:NA;1|S_AXI_HPC0_FPD:NA;1|S_AXI_HP3_FPD:NA;1|S_AXI_HP2_FPD:NA;1|S_AXI_HP1_FPD:NA;1|S_AXI_HP0_FPD:NA;1|S_AXI_ACP:NA;0|S_AXI_ACE:NA;0|SD1:NonSecure;1|SD0:NonSecure;0|SATA1:NonSecure;1|SATA0:NonSecure;1|RPU1:Secure;1|RPU0:Secure;1|QSPI:NonSecure;1|PMU:NA;1|PCIe:NonSecure;0|NAND:NonSecure;0|LDMA:NonSecure;1|GPU:NonSecure;1|GEM3:NonSecure;1|GEM2:NonSecure;0|GEM1:NonSecure;0|GEM0:NonSecure;0|FDMA:NonSecure;1|DP:NonSecure;1|DAP:NA;1|Coresight:NA;1|CSU:NA;1|APU:NA;1} \
   CONFIG.PSU__PROTECTION__SLAVES {LPD;USB3_1_XHCI;FE300000;FE3FFFFF;0|LPD;USB3_1;FF9E0000;FF9EFFFF;0|LPD;USB3_0_XHCI;FE200000;FE2FFFFF;1|LPD;USB3_0;FF9D0000;FF9DFFFF;1|LPD;UART1;FF010000;FF01FFFF;1|LPD;UART0;FF000000;FF00FFFF;1|LPD;TTC3;FF140000;FF14FFFF;1|LPD;TTC2;FF130000;FF13FFFF;1|LPD;TTC1;FF120000;FF12FFFF;1|LPD;TTC0;FF110000;FF11FFFF;1|FPD;SWDT1;FD4D0000;FD4DFFFF;1|LPD;SWDT0;FF150000;FF15FFFF;1|LPD;SPI1;FF050000;FF05FFFF;0|LPD;SPI0;FF040000;FF04FFFF;0|FPD;SMMU_REG;FD5F0000;FD5FFFFF;1|FPD;SMMU;FD800000;FDFFFFFF;1|FPD;SIOU;FD3D0000;FD3DFFFF;1|FPD;SERDES;FD400000;FD47FFFF;1|LPD;SD1;FF170000;FF17FFFF;1|LPD;SD0;FF160000;FF16FFFF;0|FPD;SATA;FD0C0000;FD0CFFFF;1|LPD;RTC;FFA60000;FFA6FFFF;1|LPD;RSA_CORE;FFCE0000;FFCEFFFF;1|LPD;RPU;FF9A0000;FF9AFFFF;1|FPD;RCPU_GIC;F9000000;F900FFFF;1|LPD;R5_TCM_RAM_GLOBAL;FFE00000;FFE3FFFF;1|LPD;R5_1_Instruction_Cache;FFEC0000;FFECFFFF;1|LPD;R5_1_Data_Cache;FFED0000;FFEDFFFF;1|LPD;R5_1_BTCM_GLOBAL;FFEB0000;FFEBFFFF;1|LPD;R5_1_ATCM_GLOBAL;FFE90000;FFE9FFFF;1|LPD;R5_0_Instruction_Cache;FFE40000;FFE4FFFF;1|LPD;R5_0_Data_Cache;FFE50000;FFE5FFFF;1|LPD;R5_0_BTCM_GLOBAL;FFE20000;FFE2FFFF;1|LPD;R5_0_ATCM_GLOBAL;FFE00000;FFE0FFFF;1|LPD;QSPI_Linear_Address;C0000000;DFFFFFFF;1|LPD;QSPI;FF0F0000;FF0FFFFF;1|LPD;PMU_RAM;FFDC0000;FFDDFFFF;1|LPD;PMU_GLOBAL;FFD80000;FFDBFFFF;1|FPD;PCIE_MAIN;FD0E0000;FD0EFFFF;0|FPD;PCIE_LOW;E0000000;EFFFFFFF;0|FPD;PCIE_HIGH2;8000000000;BFFFFFFFFF;0|FPD;PCIE_HIGH1;600000000;7FFFFFFFF;0|FPD;PCIE_DMA;FD0F0000;FD0FFFFF;0|FPD;PCIE_ATTRIB;FD480000;FD48FFFF;0|LPD;OCM_XMPU_CFG;FFA70000;FFA7FFFF;1|LPD;OCM_SLCR;FF960000;FF96FFFF;1|OCM;OCM;FFFC0000;FFFFFFFF;1|LPD;NAND;FF100000;FF10FFFF;0|LPD;MBISTJTAG;FFCF0000;FFCFFFFF;1|LPD;LPD_XPPU_SINK;FF9C0000;FF9CFFFF;1|LPD;LPD_XPPU;FF980000;FF98FFFF;1|LPD;LPD_SLCR_SECURE;FF4B0000;FF4DFFFF;1|LPD;LPD_SLCR;FF410000;FF4AFFFF;1|LPD;LPD_GPV;FE100000;FE1FFFFF;1|LPD;LPD_DMA_7;FFAF0000;FFAFFFFF;1|LPD;LPD_DMA_6;FFAE0000;FFAEFFFF;1|LPD;LPD_DMA_5;FFAD0000;FFADFFFF;1|LPD;LPD_DMA_4;FFAC0000;FFACFFFF;1|LPD;LPD_DMA_3;FFAB0000;FFABFFFF;1|LPD;LPD_DMA_2;FFAA0000;FFAAFFFF;1|LPD;LPD_DMA_1;FFA90000;FFA9FFFF;1|LPD;LPD_DMA_0;FFA80000;FFA8FFFF;1|LPD;IPI_CTRL;FF380000;FF3FFFFF;1|LPD;IOU_SLCR;FF180000;FF23FFFF;1|LPD;IOU_SECURE_SLCR;FF240000;FF24FFFF;1|LPD;IOU_SCNTRS;FF260000;FF26FFFF;1|LPD;IOU_SCNTR;FF250000;FF25FFFF;1|LPD;IOU_GPV;FE000000;FE0FFFFF;1|LPD;I2C1;FF030000;FF03FFFF;1|LPD;I2C0;FF020000;FF02FFFF;1|FPD;GPU;FD4B0000;FD4BFFFF;1|LPD;GPIO;FF0A0000;FF0AFFFF;1|LPD;GEM3;FF0E0000;FF0EFFFF;1|LPD;GEM2;FF0D0000;FF0DFFFF;0|LPD;GEM1;FF0C0000;FF0CFFFF;0|LPD;GEM0;FF0B0000;FF0BFFFF;0|FPD;FPD_XMPU_SINK;FD4F0000;FD4FFFFF;1|FPD;FPD_XMPU_CFG;FD5D0000;FD5DFFFF;1|FPD;FPD_SLCR_SECURE;FD690000;FD6CFFFF;1|FPD;FPD_SLCR;FD610000;FD68FFFF;1|FPD;FPD_GPV;FD700000;FD7FFFFF;1|FPD;FPD_DMA_CH7;FD570000;FD57FFFF;1|FPD;FPD_DMA_CH6;FD560000;FD56FFFF;1|FPD;FPD_DMA_CH5;FD550000;FD55FFFF;1|FPD;FPD_DMA_CH4;FD540000;FD54FFFF;1|FPD;FPD_DMA_CH3;FD530000;FD53FFFF;1|FPD;FPD_DMA_CH2;FD520000;FD52FFFF;1|FPD;FPD_DMA_CH1;FD510000;FD51FFFF;1|FPD;FPD_DMA_CH0;FD500000;FD50FFFF;1|LPD;EFUSE;FFCC0000;FFCCFFFF;1|FPD;Display Port;FD4A0000;FD4AFFFF;1|FPD;DPDMA;FD4C0000;FD4CFFFF;1|FPD;DDR_XMPU5_CFG;FD050000;FD05FFFF;1|FPD;DDR_XMPU4_CFG;FD040000;FD04FFFF;1|FPD;DDR_XMPU3_CFG;FD030000;FD03FFFF;1|FPD;DDR_XMPU2_CFG;FD020000;FD02FFFF;1|FPD;DDR_XMPU1_CFG;FD010000;FD01FFFF;1|FPD;DDR_XMPU0_CFG;FD000000;FD00FFFF;1|FPD;DDR_QOS_CTRL;FD090000;FD09FFFF;1|FPD;DDR_PHY;FD080000;FD08FFFF;1|DDR;DDR_LOW;0;7FFFFFFF;1|DDR;DDR_HIGH;800000000;800000000;0|FPD;DDDR_CTRL;FD070000;FD070FFF;1|LPD;Coresight;FE800000;FEFFFFFF;1|LPD;CSU_DMA;FFC80000;FFC9FFFF;1|LPD;CSU;FFCA0000;FFCAFFFF;0|LPD;CRL_APB;FF5E0000;FF85FFFF;1|FPD;CRF_APB;FD1A0000;FD2DFFFF;1|FPD;CCI_REG;FD5E0000;FD5EFFFF;1|FPD;CCI_GPV;FD6E0000;FD6EFFFF;1|LPD;CAN1;FF070000;FF07FFFF;1|LPD;CAN0;FF060000;FF06FFFF;0|FPD;APU;FD5C0000;FD5CFFFF;1|LPD;APM_INTC_IOU;FFA20000;FFA2FFFF;1|LPD;APM_FPD_LPD;FFA30000;FFA3FFFF;1|FPD;APM_5;FD490000;FD49FFFF;1|FPD;APM_0;FD0B0000;FD0BFFFF;1|LPD;APM2;FFA10000;FFA1FFFF;1|LPD;APM1;FFA00000;FFA0FFFF;1|LPD;AMS;FFA50000;FFA5FFFF;1|FPD;AFI_5;FD3B0000;FD3BFFFF;1|FPD;AFI_4;FD3A0000;FD3AFFFF;1|FPD;AFI_3;FD390000;FD39FFFF;1|FPD;AFI_2;FD380000;FD38FFFF;1|FPD;AFI_1;FD370000;FD37FFFF;1|FPD;AFI_0;FD360000;FD36FFFF;1|LPD;AFIFM6;FF9B0000;FF9BFFFF;1|FPD;ACPU_GIC;F9000000;F907FFFF;1} \
   CONFIG.PSU__PSS_REF_CLK__FREQMHZ {33.333} \
   CONFIG.PSU__QSPI_COHERENCY {0} \
   CONFIG.PSU__QSPI__GRP_FBCLK__ENABLE {1} \
   CONFIG.PSU__QSPI__GRP_FBCLK__IO {MIO 6} \
   CONFIG.PSU__QSPI__PERIPHERAL__DATA_MODE {x4} \
   CONFIG.PSU__QSPI__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__QSPI__PERIPHERAL__IO {MIO 0 .. 5} \
   CONFIG.PSU__QSPI__PERIPHERAL__MODE {Single} \
   CONFIG.PSU__SATA__LANE0__ENABLE {0} \
   CONFIG.PSU__SATA__LANE1__ENABLE {1} \
   CONFIG.PSU__SATA__LANE1__IO {GT Lane3} \
   CONFIG.PSU__SATA__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SATA__REF_CLK_FREQ {125} \
   CONFIG.PSU__SATA__REF_CLK_SEL {Ref Clk1} \
   CONFIG.PSU__SAXIGP0__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP1__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP2__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP3__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP4__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP5__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP6__DATA_WIDTH {128} \
   CONFIG.PSU__SD1_COHERENCY {0} \
   CONFIG.PSU__SD1__DATA_TRANSFER_MODE {4Bit} \
   CONFIG.PSU__SD1__GRP_CD__ENABLE {1} \
   CONFIG.PSU__SD1__GRP_CD__IO {MIO 45} \
   CONFIG.PSU__SD1__GRP_POW__ENABLE {0} \
   CONFIG.PSU__SD1__GRP_WP__ENABLE {0} \
   CONFIG.PSU__SD1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SD1__PERIPHERAL__IO {MIO 46 .. 51} \
   CONFIG.PSU__SD1__RESET__ENABLE {0} \
   CONFIG.PSU__SD1__SLOT_TYPE {SD 2.0} \
   CONFIG.PSU__SWDT0__CLOCK__ENABLE {0} \
   CONFIG.PSU__SWDT0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SWDT0__RESET__ENABLE {0} \
   CONFIG.PSU__SWDT1__CLOCK__ENABLE {0} \
   CONFIG.PSU__SWDT1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SWDT1__RESET__ENABLE {0} \
   CONFIG.PSU__TTC0__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC0__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__TTC1__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC1__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__TTC2__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC2__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC2__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__TTC3__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC3__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC3__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__UART0__BAUD_RATE {115200} \
   CONFIG.PSU__UART0__MODEM__ENABLE {0} \
   CONFIG.PSU__UART0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__UART0__PERIPHERAL__IO {MIO 18 .. 19} \
   CONFIG.PSU__UART1__BAUD_RATE {115200} \
   CONFIG.PSU__UART1__MODEM__ENABLE {0} \
   CONFIG.PSU__UART1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__UART1__PERIPHERAL__IO {MIO 20 .. 21} \
   CONFIG.PSU__USB0_COHERENCY {0} \
   CONFIG.PSU__USB0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__USB0__PERIPHERAL__IO {MIO 52 .. 63} \
   CONFIG.PSU__USB0__REF_CLK_FREQ {26} \
   CONFIG.PSU__USB0__REF_CLK_SEL {Ref Clk2} \
   CONFIG.PSU__USB2_0__EMIO__ENABLE {0} \
   CONFIG.PSU__USB3_0__EMIO__ENABLE {0} \
   CONFIG.PSU__USB3_0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__USB3_0__PERIPHERAL__IO {GT Lane2} \
   CONFIG.PSU__USE__IRQ0 {1} \
   CONFIG.PSU__USE__IRQ1 {1} \
   CONFIG.PSU__USE__M_AXI_GP0 {1} \
   CONFIG.PSU__USE__M_AXI_GP1 {1} \
   CONFIG.PSU__USE__M_AXI_GP2 {1} \
   CONFIG.PSU__USE__S_AXI_GP0 {1} \
   CONFIG.PSU__USE__S_AXI_GP1 {1} \
   CONFIG.PSU__USE__S_AXI_GP2 {1} \
   CONFIG.PSU__USE__S_AXI_GP3 {1} \
   CONFIG.PSU__USE__S_AXI_GP4 {1} \
   CONFIG.PSU__USE__S_AXI_GP5 {1} \
   CONFIG.PSU__USE__S_AXI_GP6 {1} \
   CONFIG.SUBPRESET1 {Custom} \
 ] $zynq_us

  # Create interface connections
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins axi_mem_HP3/S00_AXI] [get_bd_intf_pins video/m_axi_hdmi_tx]
  connect_bd_intf_net -intf_net S00_AXI_2 [get_bd_intf_pins axi_mem_HP1/S00_AXI] [get_bd_intf_pins video/m_axi_flow]
  connect_bd_intf_net -intf_net S00_AXI_3 [get_bd_intf_pins axi_mem_HP2/S00_AXI] [get_bd_intf_pins video/m_axi_filter]
  connect_bd_intf_net -intf_net S01_AXI_1 [get_bd_intf_pins axi_mem_HP2/S01_AXI] [get_bd_intf_pins optical_flow_0/m_axi_curr_frame]
  connect_bd_intf_net -intf_net S01_AXI_2 [get_bd_intf_pins axi_mem_HP3/S01_AXI] [get_bd_intf_pins optical_flow_0/m_axi_prev_frame]
  connect_bd_intf_net -intf_net S01_AXI_3 [get_bd_intf_pins axi_mem_HP1/S01_AXI] [get_bd_intf_pins video/m_axi_hdmi_rx]
  connect_bd_intf_net -intf_net S02_AXI_1 [get_bd_intf_pins axi_mem_HP3/S02_AXI] [get_bd_intf_pins optical_flow_0/m_axi_out_frame]
  connect_bd_intf_net -intf_net axi_gpio_0_GPIO [get_bd_intf_ports dip_switch_4bits] [get_bd_intf_pins gpio_sws/GPIO]
  connect_bd_intf_net -intf_net axi_gpio_0_GPIO1 [get_bd_intf_ports led_4bits] [get_bd_intf_pins gpio_leds/GPIO]
  connect_bd_intf_net -intf_net axi_gpio_0_GPIO2 [get_bd_intf_ports push_button_4bits] [get_bd_intf_pins gpio_btns/GPIO]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins axi_register_slice_0/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_M05_AXI [get_bd_intf_pins axi_intc_0/s_axi] [get_bd_intf_pins axi_interconnect/M05_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_M06_AXI [get_bd_intf_pins axi_interconnect/M06_AXI] [get_bd_intf_pins reset_control/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_M07_AXI [get_bd_intf_pins axi_interconnect/M07_AXI] [get_bd_intf_pins video/s_axi_AXILiteS]
  connect_bd_intf_net -intf_net axi_interconnect_M08_AXI [get_bd_intf_pins axi_interconnect/M08_AXI] [get_bd_intf_pins video/s_axi_AXILiteS1]
  connect_bd_intf_net -intf_net axi_interconnect_M09_AXI [get_bd_intf_pins axi_interconnect/M09_AXI] [get_bd_intf_pins video/s_axi_AXILiteS2]
  connect_bd_intf_net -intf_net axi_interconnect_M10_AXI [get_bd_intf_pins axi_interconnect/M10_AXI] [get_bd_intf_pins video/s_axi_AXILiteS3]
  connect_bd_intf_net -intf_net axi_interconnect_M11_AXI [get_bd_intf_pins axi_interconnect/M11_AXI] [get_bd_intf_pins iop_pmod0/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_M12_AXI [get_bd_intf_pins axi_interconnect/M12_AXI] [get_bd_intf_pins iop_pmod1/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_M13_AXI [get_bd_intf_pins axi_interconnect/M13_AXI] [get_bd_intf_pins gpio_sws/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_M14_AXI [get_bd_intf_pins axi_interconnect/M14_AXI] [get_bd_intf_pins gpio_btns/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_M15_AXI [get_bd_intf_pins axi_interconnect/M15_AXI] [get_bd_intf_pins gpio_leds/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_M16_AXI [get_bd_intf_pins axi_interconnect/M16_AXI] [get_bd_intf_pins shutdown_HP0_FPD/S_AXI_CTRL]
  connect_bd_intf_net -intf_net axi_interconnect_M17_AXI [get_bd_intf_pins axi_interconnect/M17_AXI] [get_bd_intf_pins shutdown_LPD/S_AXI_CTRL]
  connect_bd_intf_net -intf_net axi_interconnect_M18_AXI [get_bd_intf_pins axi_interconnect/M18_AXI] [get_bd_intf_pins shutdown_HP2_FPD/S_AXI_CTRL]
  connect_bd_intf_net -intf_net axi_interconnect_M19_AXI [get_bd_intf_pins axi_interconnect/M19_AXI] [get_bd_intf_pins video/s_axi_CTRL]
  connect_bd_intf_net -intf_net axi_interconnect_M20_AXI [get_bd_intf_pins axi_interconnect/M20_AXI] [get_bd_intf_pins video/s_axi_CTRL1]
  connect_bd_intf_net -intf_net axi_interconnect_M21_AXI [get_bd_intf_pins axi_interconnect/M21_AXI] [get_bd_intf_pins filter_pipeline_0/s_axi_AXILiteS]
  connect_bd_intf_net -intf_net axi_interconnect_M22_AXI [get_bd_intf_pins axi_interconnect/M22_AXI] [get_bd_intf_pins optical_flow_0/s_axi_AXILiteS]
  connect_bd_intf_net -intf_net axi_interconnect_M23_AXI [get_bd_intf_pins axi_interconnect/M23_AXI] [get_bd_intf_pins video/s_axi_AXILiteS4]
  connect_bd_intf_net -intf_net axi_mem_intercon_1_M00_AXI [get_bd_intf_pins axi_mem_HP2/M00_AXI] [get_bd_intf_pins shutdown_HP2_FPD/S_AXI]
  connect_bd_intf_net -intf_net axi_mem_intercon_2_M00_AXI [get_bd_intf_pins axi_mem_HP1/M00_AXI] [get_bd_intf_pins zynq_us/S_AXI_HP1_FPD]
  connect_bd_intf_net -intf_net axi_mem_intercon_3_M00_AXI [get_bd_intf_pins axi_mem_HP3/M00_AXI] [get_bd_intf_pins zynq_us/S_AXI_HP3_FPD]
  connect_bd_intf_net -intf_net axi_mem_intercon_4_M00_AXI [get_bd_intf_pins axi_mem_HPC0/M00_AXI] [get_bd_intf_pins zynq_us/S_AXI_HPC0_FPD]
  connect_bd_intf_net -intf_net axi_mem_intercon_M00_AXI [get_bd_intf_pins axi_mem_HP0/M00_AXI] [get_bd_intf_pins shutdown_HP0_FPD/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI [get_bd_intf_pins axi_register_slice_0/M_AXI] [get_bd_intf_pins shutdown_LPD/S_AXI]
  connect_bd_intf_net -intf_net clk_125_1 [get_bd_intf_ports clk_125] [get_bd_intf_pins util_ds_buf_0/CLK_IN_D]
  connect_bd_intf_net -intf_net filter_pipeline_0_m_axi_frame [get_bd_intf_pins axi_mem_HPC0/S00_AXI] [get_bd_intf_pins filter_pipeline_0/m_axi_frame]
  connect_bd_intf_net -intf_net intf_net_axi_interconnect_M04_AXI [get_bd_intf_pins axi_interconnect/M04_AXI] [get_bd_intf_pins fmch_axi_iic/S_AXI]
  connect_bd_intf_net -intf_net intf_net_bdry_in_DRU_CLK_IN [get_bd_intf_ports DRU_CLK_IN] [get_bd_intf_pins video/DRU_CLK_IN]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_rx_ss_DDC_OUT [get_bd_intf_ports RX_DDC_OUT] [get_bd_intf_pins video/RX_DDC_OUT]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_tx_ss_DDC_OUT [get_bd_intf_ports TX_DDC_OUT] [get_bd_intf_pins video/TX_DDC_OUT]
  connect_bd_intf_net -intf_net intf_net_zynq_us_M_AXI_HPM0_LPD [get_bd_intf_pins axi_interconnect/S00_AXI] [get_bd_intf_pins zynq_us/M_AXI_HPM0_LPD]
  connect_bd_intf_net -intf_net intf_net_zynq_us_ss_0_IIC [get_bd_intf_ports fmch_iic] [get_bd_intf_pins fmch_axi_iic/IIC]
  connect_bd_intf_net -intf_net intf_net_zynq_us_ss_0_M00_AXI [get_bd_intf_pins axi_interconnect/M00_AXI] [get_bd_intf_pins video/vid_phy_axi4lite]
  connect_bd_intf_net -intf_net intf_net_zynq_us_ss_0_M01_AXI [get_bd_intf_pins axi_interconnect/M01_AXI] [get_bd_intf_pins video/S_AXI_CPU_IN]
  connect_bd_intf_net -intf_net intf_net_zynq_us_ss_0_M02_AXI [get_bd_intf_pins axi_interconnect/M02_AXI] [get_bd_intf_pins video/S_AXI_CPU_IN1]
  connect_bd_intf_net -intf_net mdm_0_MBDEBUG_0 [get_bd_intf_pins iop_pmod0/DEBUG] [get_bd_intf_pins mdm_0/MBDEBUG_0]
  connect_bd_intf_net -intf_net mdm_0_MBDEBUG_1 [get_bd_intf_pins iop_pmod1/DEBUG] [get_bd_intf_pins mdm_0/MBDEBUG_1]
  connect_bd_intf_net -intf_net pmod0_M_AXI [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins iop_pmod0/M_AXI]
  connect_bd_intf_net -intf_net pmod1_M_AXI [get_bd_intf_pins axi_interconnect_0/S01_AXI] [get_bd_intf_pins iop_pmod1/M_AXI]
  connect_bd_intf_net -intf_net pr_axi_shutdown_mana_0_M_AXI [get_bd_intf_pins shutdown_LPD/M_AXI] [get_bd_intf_pins zynq_us/S_AXI_LPD]
  connect_bd_intf_net -intf_net shutdown_HP0_M_AXI [get_bd_intf_pins shutdown_HP0_FPD/M_AXI] [get_bd_intf_pins zynq_us/S_AXI_HP0_FPD]
  connect_bd_intf_net -intf_net shutdown_HP2_M_AXI [get_bd_intf_pins shutdown_HP2_FPD/M_AXI] [get_bd_intf_pins zynq_us/S_AXI_HP2_FPD]
  connect_bd_intf_net -intf_net video_m_axi_overlay [get_bd_intf_pins axi_mem_HP0/S01_AXI] [get_bd_intf_pins video/m_axi_overlay]
  connect_bd_intf_net -intf_net video_m_axi_webcam [get_bd_intf_pins axi_mem_HP0/S00_AXI] [get_bd_intf_pins video/m_axi_webcam]
  connect_bd_intf_net -intf_net zynq_us_ss_0_M03_AXI [get_bd_intf_pins axi_interconnect/M03_AXI] [get_bd_intf_pins video/S_AXI_LITE]

  # Create port connections
  connect_bd_net -net ARESETN_1 [get_bd_pins axi_mem_HP0/ARESETN] [get_bd_pins axi_mem_HP1/ARESETN] [get_bd_pins axi_mem_HP2/ARESETN] [get_bd_pins axi_mem_HP3/ARESETN] [get_bd_pins axi_mem_HPC0/ARESETN] [get_bd_pins rst_processor_1_300M/interconnect_aresetn]
  connect_bd_net -net Net [get_bd_ports pmod0] [get_bd_pins pmod0_buf/IOBUF_IO_IO]
  connect_bd_net -net Net1 [get_bd_ports pmod1] [get_bd_pins pmod1_buf/IOBUF_IO_IO]
  connect_bd_net -net axi_gpio_0_gpio_io_o [get_bd_pins reset_control/gpio_io_o] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din]
  connect_bd_net -net axi_intc_0_irq [get_bd_pins axi_intc_0/irq] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net axi_vdma_0_mm2s_introut [get_bd_pins video/mm2s_introut] [get_bd_pins xlconcat0/In4]
  connect_bd_net -net axi_vdma_0_s2mm_introut [get_bd_pins video/s2mm_introut] [get_bd_pins xlconcat0/In3]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_0/dcm_locked]
  connect_bd_net -net data_i_1 [get_bd_pins iop_pmod0/data_i] [get_bd_pins pmod0_buf/IOBUF_IO_O]
  connect_bd_net -net data_i_2 [get_bd_pins iop_pmod1/data_i] [get_bd_pins pmod1_buf/IOBUF_IO_O]
  connect_bd_net -net gpio_btns_ip2intc_irpt [get_bd_pins gpio_btns/ip2intc_irpt] [get_bd_pins xlconcat0/In8]
  connect_bd_net -net gpio_sws_ip2intc_irpt [get_bd_pins gpio_sws/ip2intc_irpt] [get_bd_pins xlconcat0/In7]
  connect_bd_net -net mb_pmod1_intr_ack_Dout [get_bd_pins iop_pmod1/intr_ack] [get_bd_pins mb_pmod1_intr_ack/Dout]
  connect_bd_net -net mb_pmod1_reset_Dout [get_bd_pins iop_pmod1/aux_reset_in] [get_bd_pins mb_pmod1_reset/Dout]
  connect_bd_net -net mdm_0_Debug_SYS_Rst [get_bd_pins iop_pmod0/mb_debug_sys_rst] [get_bd_pins iop_pmod1/mb_debug_sys_rst] [get_bd_pins mdm_0/Debug_SYS_Rst]
  connect_bd_net -net net_bdry_in_HDMI_RX_CLK_N_IN [get_bd_ports HDMI_RX_CLK_N_IN] [get_bd_pins video/HDMI_RX_CLK_N_IN]
  connect_bd_net -net net_bdry_in_HDMI_RX_CLK_P_IN [get_bd_ports HDMI_RX_CLK_P_IN] [get_bd_pins video/HDMI_RX_CLK_P_IN]
  connect_bd_net -net net_bdry_in_HDMI_RX_DAT_N_IN [get_bd_ports HDMI_RX_DAT_N_IN] [get_bd_pins video/HDMI_RX_DAT_N_IN]
  connect_bd_net -net net_bdry_in_HDMI_RX_DAT_P_IN [get_bd_ports HDMI_RX_DAT_P_IN] [get_bd_pins video/HDMI_RX_DAT_P_IN]
  connect_bd_net -net net_bdry_in_IDT_8T49N241_LOL_IN [get_bd_ports IDT_8T49N241_LOL_IN] [get_bd_pins video/IDT_8T49N241_LOL_IN]
  connect_bd_net -net net_bdry_in_RX_DET_IN [get_bd_ports RX_DET_IN] [get_bd_pins video/RX_DET_IN]
  connect_bd_net -net net_bdry_in_TX_HPD_IN [get_bd_ports TX_HPD_IN] [get_bd_pins video/TX_HPD_IN]
  connect_bd_net -net net_bdry_in_TX_REFCLK_N_IN [get_bd_ports TX_REFCLK_N_IN] [get_bd_pins video/TX_REFCLK_N_IN]
  connect_bd_net -net net_bdry_in_TX_REFCLK_P_IN [get_bd_ports TX_REFCLK_P_IN] [get_bd_pins video/TX_REFCLK_P_IN]
  connect_bd_net -net net_bdry_in_reset [get_bd_ports reset] [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins rst_processor_1_100M/ext_reset_in] [get_bd_pins rst_processor_1_300M/ext_reset_in]
  connect_bd_net -net net_rst_processor_1_100M_interconnect_aresetn [get_bd_pins axi_interconnect/ARESETN] [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins rst_processor_1_100M/interconnect_aresetn]
  connect_bd_net -net net_v_hdmi_rx_ss_hpd [get_bd_ports RX_HPD_OUT] [get_bd_pins video/RX_HPD_OUT]
  connect_bd_net -net net_v_hdmi_rx_ss_irq [get_bd_pins video/irq] [get_bd_pins xlconcat0/In1]
  connect_bd_net -net net_v_hdmi_tx_ss_irq [get_bd_pins video/irq1] [get_bd_pins xlconcat0/In2]
  connect_bd_net -net net_vcc_const_dout [get_bd_ports TX_EN_OUT] [get_bd_pins vcc_const/dout] [get_bd_pins video/TX_EN_OUT]
  connect_bd_net -net net_vid_phy_controller_irq [get_bd_pins video/irq2] [get_bd_pins xlconcat0/In0]
  connect_bd_net -net net_vid_phy_controller_phy_txn_out [get_bd_ports HDMI_TX_DAT_N_OUT] [get_bd_pins video/HDMI_TX_DAT_N_OUT]
  connect_bd_net -net net_vid_phy_controller_phy_txp_out [get_bd_ports HDMI_TX_DAT_P_OUT] [get_bd_pins video/HDMI_TX_DAT_P_OUT]
  connect_bd_net -net net_vid_phy_controller_rx_tmds_clk_n [get_bd_ports RX_REFCLK_N_OUT] [get_bd_pins video/RX_REFCLK_N_OUT]
  connect_bd_net -net net_vid_phy_controller_rx_tmds_clk_p [get_bd_ports RX_REFCLK_P_OUT] [get_bd_pins video/RX_REFCLK_P_OUT]
  connect_bd_net -net net_vid_phy_controller_tx_tmds_clk_n [get_bd_ports HDMI_TX_CLK_N_OUT] [get_bd_pins video/HDMI_TX_CLK_N_OUT]
  connect_bd_net -net net_vid_phy_controller_tx_tmds_clk_p [get_bd_ports HDMI_TX_CLK_P_OUT] [get_bd_pins video/HDMI_TX_CLK_P_OUT]
  connect_bd_net -net net_zynq_us_pl_resetn0 [get_bd_pins proc_sys_reset_0/aux_reset_in] [get_bd_pins rst_processor_1_100M/aux_reset_in] [get_bd_pins rst_processor_1_100M/dcm_locked] [get_bd_pins rst_processor_1_300M/aux_reset_in] [get_bd_pins rst_processor_1_300M/dcm_locked] [get_bd_pins zynq_us/pl_resetn0]
  connect_bd_net -net net_zynq_us_ss_0_clk_out2 [get_bd_pins axi_interconnect/M07_ACLK] [get_bd_pins axi_interconnect/M08_ACLK] [get_bd_pins axi_interconnect/M09_ACLK] [get_bd_pins axi_interconnect/M10_ACLK] [get_bd_pins axi_interconnect/M16_ACLK] [get_bd_pins axi_interconnect/M18_ACLK] [get_bd_pins axi_interconnect/M19_ACLK] [get_bd_pins axi_interconnect/M20_ACLK] [get_bd_pins axi_interconnect/M21_ACLK] [get_bd_pins axi_interconnect/M22_ACLK] [get_bd_pins axi_interconnect/M23_ACLK] [get_bd_pins axi_mem_HP0/ACLK] [get_bd_pins axi_mem_HP0/M00_ACLK] [get_bd_pins axi_mem_HP0/S00_ACLK] [get_bd_pins axi_mem_HP0/S01_ACLK] [get_bd_pins axi_mem_HP1/ACLK] [get_bd_pins axi_mem_HP1/M00_ACLK] [get_bd_pins axi_mem_HP1/S00_ACLK] [get_bd_pins axi_mem_HP1/S01_ACLK] [get_bd_pins axi_mem_HP2/ACLK] [get_bd_pins axi_mem_HP2/M00_ACLK] [get_bd_pins axi_mem_HP2/S00_ACLK] [get_bd_pins axi_mem_HP2/S01_ACLK] [get_bd_pins axi_mem_HP3/ACLK] [get_bd_pins axi_mem_HP3/M00_ACLK] [get_bd_pins axi_mem_HP3/S00_ACLK] [get_bd_pins axi_mem_HP3/S01_ACLK] [get_bd_pins axi_mem_HP3/S02_ACLK] [get_bd_pins axi_mem_HPC0/ACLK] [get_bd_pins axi_mem_HPC0/M00_ACLK] [get_bd_pins axi_mem_HPC0/S00_ACLK] [get_bd_pins filter_pipeline_0/ap_clk] [get_bd_pins optical_flow_0/ap_clk] [get_bd_pins rst_processor_1_300M/slowest_sync_clk] [get_bd_pins shutdown_HP0_FPD/clk] [get_bd_pins shutdown_HP2_FPD/clk] [get_bd_pins video/aclk] [get_bd_pins zynq_us/pl_clk1] [get_bd_pins zynq_us/saxihp0_fpd_aclk] [get_bd_pins zynq_us/saxihp1_fpd_aclk] [get_bd_pins zynq_us/saxihp2_fpd_aclk] [get_bd_pins zynq_us/saxihp3_fpd_aclk] [get_bd_pins zynq_us/saxihpc0_fpd_aclk] [get_bd_pins zynq_us/saxihpc1_fpd_aclk]
  connect_bd_net -net net_zynq_us_ss_0_dcm_locked [get_bd_pins axi_interconnect/M07_ARESETN] [get_bd_pins axi_interconnect/M08_ARESETN] [get_bd_pins axi_interconnect/M09_ARESETN] [get_bd_pins axi_interconnect/M10_ARESETN] [get_bd_pins axi_interconnect/M16_ARESETN] [get_bd_pins axi_interconnect/M18_ARESETN] [get_bd_pins axi_interconnect/M19_ARESETN] [get_bd_pins axi_interconnect/M20_ARESETN] [get_bd_pins axi_interconnect/M21_ARESETN] [get_bd_pins axi_interconnect/M22_ARESETN] [get_bd_pins axi_interconnect/M23_ARESETN] [get_bd_pins axi_mem_HP0/M00_ARESETN] [get_bd_pins axi_mem_HP0/S00_ARESETN] [get_bd_pins axi_mem_HP0/S01_ARESETN] [get_bd_pins axi_mem_HP1/M00_ARESETN] [get_bd_pins axi_mem_HP1/S00_ARESETN] [get_bd_pins axi_mem_HP1/S01_ARESETN] [get_bd_pins axi_mem_HP2/M00_ARESETN] [get_bd_pins axi_mem_HP2/S00_ARESETN] [get_bd_pins axi_mem_HP2/S01_ARESETN] [get_bd_pins axi_mem_HP3/M00_ARESETN] [get_bd_pins axi_mem_HP3/S00_ARESETN] [get_bd_pins axi_mem_HP3/S01_ARESETN] [get_bd_pins axi_mem_HP3/S02_ARESETN] [get_bd_pins axi_mem_HPC0/M00_ARESETN] [get_bd_pins axi_mem_HPC0/S00_ARESETN] [get_bd_pins filter_pipeline_0/ap_rst_n] [get_bd_pins optical_flow_0/ap_rst_n] [get_bd_pins rst_processor_1_300M/peripheral_aresetn] [get_bd_pins shutdown_HP0_FPD/resetn] [get_bd_pins shutdown_HP2_FPD/resetn] [get_bd_pins video/aresetn]
  connect_bd_net -net net_zynq_us_ss_0_peripheral_aresetn [get_bd_pins axi_intc_0/s_axi_aresetn] [get_bd_pins axi_interconnect/M00_ARESETN] [get_bd_pins axi_interconnect/M01_ARESETN] [get_bd_pins axi_interconnect/M02_ARESETN] [get_bd_pins axi_interconnect/M03_ARESETN] [get_bd_pins axi_interconnect/M04_ARESETN] [get_bd_pins axi_interconnect/M05_ARESETN] [get_bd_pins axi_interconnect/M06_ARESETN] [get_bd_pins axi_interconnect/M11_ARESETN] [get_bd_pins axi_interconnect/M12_ARESETN] [get_bd_pins axi_interconnect/M13_ARESETN] [get_bd_pins axi_interconnect/M14_ARESETN] [get_bd_pins axi_interconnect/M15_ARESETN] [get_bd_pins axi_interconnect/M17_ARESETN] [get_bd_pins axi_interconnect/S00_ARESETN] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins fmch_axi_iic/s_axi_aresetn] [get_bd_pins gpio_btns/s_axi_aresetn] [get_bd_pins gpio_leds/s_axi_aresetn] [get_bd_pins gpio_sws/s_axi_aresetn] [get_bd_pins iop_pmod0/s_axi_aresetn] [get_bd_pins iop_pmod1/s_axi_aresetn] [get_bd_pins reset_control/s_axi_aresetn] [get_bd_pins rst_processor_1_100M/peripheral_aresetn] [get_bd_pins video/s_axi_cpu_aresetn]
  connect_bd_net -net net_zynq_us_ss_0_s_axi_aclk [get_bd_pins axi_intc_0/s_axi_aclk] [get_bd_pins axi_interconnect/ACLK] [get_bd_pins axi_interconnect/M00_ACLK] [get_bd_pins axi_interconnect/M01_ACLK] [get_bd_pins axi_interconnect/M02_ACLK] [get_bd_pins axi_interconnect/M03_ACLK] [get_bd_pins axi_interconnect/M04_ACLK] [get_bd_pins axi_interconnect/M05_ACLK] [get_bd_pins axi_interconnect/M06_ACLK] [get_bd_pins axi_interconnect/M11_ACLK] [get_bd_pins axi_interconnect/M12_ACLK] [get_bd_pins axi_interconnect/M13_ACLK] [get_bd_pins axi_interconnect/M14_ACLK] [get_bd_pins axi_interconnect/M15_ACLK] [get_bd_pins axi_interconnect/M17_ACLK] [get_bd_pins axi_interconnect/S00_ACLK] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_interconnect_0/S01_ACLK] [get_bd_pins axi_register_slice_0/aclk] [get_bd_pins fmch_axi_iic/s_axi_aclk] [get_bd_pins gpio_btns/s_axi_aclk] [get_bd_pins gpio_leds/s_axi_aclk] [get_bd_pins gpio_sws/s_axi_aclk] [get_bd_pins iop_pmod0/clk_100M] [get_bd_pins iop_pmod1/clk_100M] [get_bd_pins reset_control/s_axi_aclk] [get_bd_pins rst_processor_1_100M/slowest_sync_clk] [get_bd_pins shutdown_LPD/clk] [get_bd_pins video/s_axi_cpu_aclk] [get_bd_pins zynq_us/maxihpm0_fpd_aclk] [get_bd_pins zynq_us/maxihpm0_lpd_aclk] [get_bd_pins zynq_us/maxihpm1_fpd_aclk] [get_bd_pins zynq_us/pl_clk0] [get_bd_pins zynq_us/saxi_lpd_aclk]
  connect_bd_net -net optical_flow_0_interrupt [get_bd_pins optical_flow_0/interrupt] [get_bd_pins xlconcat0/In9]
  connect_bd_net -net pmod0_data_o [get_bd_pins iop_pmod0/data_o] [get_bd_pins pmod0_buf/IOBUF_IO_I]
  connect_bd_net -net pmod0_intr_req [get_bd_pins iop_pmod0/intr_req] [get_bd_pins xlconcat0/In5]
  connect_bd_net -net pmod0_intr_req_Dout [get_bd_pins iop_pmod0/intr_ack] [get_bd_pins mb_pmod0_intr_ack/Dout]
  connect_bd_net -net pmod0_peripheral_aresetn [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins iop_pmod0/peripheral_aresetn]
  connect_bd_net -net pmod0_reset_Dout [get_bd_pins iop_pmod0/aux_reset_in] [get_bd_pins mb_pmod0_reset/Dout]
  connect_bd_net -net pmod0_tri_o [get_bd_pins iop_pmod0/tri_o] [get_bd_pins pmod0_buf/IOBUF_IO_T]
  connect_bd_net -net pmod1_data_o [get_bd_pins iop_pmod1/data_o] [get_bd_pins pmod1_buf/IOBUF_IO_I]
  connect_bd_net -net pmod1_intr_req [get_bd_pins iop_pmod1/intr_req] [get_bd_pins xlconcat0/In6]
  connect_bd_net -net pmod1_peripheral_aresetn [get_bd_pins axi_interconnect_0/S01_ARESETN] [get_bd_pins axi_register_slice_0/aresetn] [get_bd_pins iop_pmod1/peripheral_aresetn] [get_bd_pins shutdown_LPD/resetn]
  connect_bd_net -net pmod1_tri_o [get_bd_pins iop_pmod1/tri_o] [get_bd_pins pmod1_buf/IOBUF_IO_T]
  connect_bd_net -net util_ds_buf_0_IBUF_OUT [get_bd_pins clk_wiz_0/clk_in1] [get_bd_pins util_ds_buf_0/IBUF_OUT]
  connect_bd_net -net xlconcat0_dout [get_bd_pins axi_intc_0/intr] [get_bd_pins xlconcat0/dout]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins xlconcat_0/dout] [get_bd_pins zynq_us/pl_ps_irq0]
  connect_bd_net -net xlslice_0_Dout [get_bd_ports IDT_8T49N241_RST_OUT] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_ports HDMI_RX_LS_OE] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net zynq_us_emio_gpio_o [get_bd_pins mb_pmod0_intr_ack/Din] [get_bd_pins mb_pmod0_reset/Din] [get_bd_pins mb_pmod1_intr_ack/Din] [get_bd_pins mb_pmod1_reset/Din] [get_bd_pins zynq_us/emio_gpio_o]

  # Create address segments
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces filter_pipeline_0/Data_m_axi_frame] [get_bd_addr_segs zynq_us/SAXIGP0/HPC0_DDR_LOW] SEG_zynq_us_HPC0_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces filter_pipeline_0/Data_m_axi_frame] [get_bd_addr_segs zynq_us/SAXIGP0/HPC0_QSPI] SEG_zynq_us_HPC0_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces optical_flow_0/Data_m_axi_curr_frame] [get_bd_addr_segs zynq_us/SAXIGP4/HP2_DDR_LOW] SEG_zynq_us_HP2_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces optical_flow_0/Data_m_axi_curr_frame] [get_bd_addr_segs zynq_us/SAXIGP4/HP2_QSPI] SEG_zynq_us_HP2_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces optical_flow_0/Data_m_axi_prev_frame] [get_bd_addr_segs zynq_us/SAXIGP5/HP3_DDR_LOW] SEG_zynq_us_HP3_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces optical_flow_0/Data_m_axi_out_frame] [get_bd_addr_segs zynq_us/SAXIGP5/HP3_DDR_LOW] SEG_zynq_us_HP3_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces optical_flow_0/Data_m_axi_prev_frame] [get_bd_addr_segs zynq_us/SAXIGP5/HP3_QSPI] SEG_zynq_us_HP3_QSPI
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces optical_flow_0/Data_m_axi_out_frame] [get_bd_addr_segs zynq_us/SAXIGP5/HP3_QSPI] SEG_zynq_us_HP3_QSPI
  create_bd_addr_seg -range 0x00001000 -offset 0x80044000 [get_bd_addr_spaces zynq_us/Data] [get_bd_addr_segs reset_control/S_AXI/Reg] SEG_axi_gpio_0_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0x80045000 [get_bd_addr_spaces zynq_us/Data] [get_bd_addr_segs gpio_btns/S_AXI/Reg] SEG_axi_gpio_0_Reg1
  create_bd_addr_seg -range 0x00001000 -offset 0x80043000 [get_bd_addr_spaces zynq_us/Data] [get_bd_addr_segs axi_intc_0/S_AXI/Reg] SEG_axi_intc_0_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0x80042000 [get_bd_addr_spaces zynq_us/Data] [get_bd_addr_segs video/axi_vdma/S_AXI_LITE/Reg] SEG_axi_vdma_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x80050000 [get_bd_addr_spaces zynq_us/Data] [get_bd_addr_segs video/hdmi_in/color_convert/s_axi_AXILiteS/Reg] SEG_color_convert_1_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x80010000 [get_bd_addr_spaces zynq_us/Data] [get_bd_addr_segs filter_pipeline_0/s_axi_AXILiteS/Reg] SEG_filter_pipeline_0_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0x80041000 [get_bd_addr_spaces zynq_us/Data] [get_bd_addr_segs fmch_axi_iic/S_AXI/Reg] SEG_fmch_axi_iic_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0x80046000 [get_bd_addr_spaces zynq_us/Data] [get_bd_addr_segs gpio_leds/S_AXI/Reg] SEG_gpio_leds_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0x80040000 [get_bd_addr_spaces zynq_us/Data] [get_bd_addr_segs gpio_sws/S_AXI/Reg] SEG_gpio_sws_Reg
  create_bd_addr_seg -range 0x00080000 -offset 0x80180000 [get_bd_addr_spaces zynq_us/Data] [get_bd_addr_segs video/hdmi_out/logo_output_0/s_axi_AXILiteS/Reg] SEG_logo_output_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x800A0000 [get_bd_addr_spaces zynq_us/Data] [get_bd_addr_segs iop_pmod0/mb_bram_ctrl/S_AXI/Mem0] SEG_mb_bram_ctrl_Mem0
  create_bd_addr_seg -range 0x00010000 -offset 0x800B0000 [get_bd_addr_spaces zynq_us/Data] [get_bd_addr_segs iop_pmod1/mb_bram_ctrl/S_AXI/Mem0] SEG_mb_bram_ctrl_Mem01
  create_bd_addr_seg -range 0x00010000 -offset 0x80100000 [get_bd_addr_spaces zynq_us/Data] [get_bd_addr_segs optical_flow_0/s_axi_AXILiteS/Reg] SEG_optical_flow_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x80070000 [get_bd_addr_spaces zynq_us/Data] [get_bd_addr_segs video/hdmi_in/pixel_pack/s_axi_AXILiteS/Reg] SEG_pixel_pack_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x800C0000 [get_bd_addr_spaces zynq_us/Data] [get_bd_addr_segs shutdown_LPD/S_AXI_CTRL/Reg] SEG_pr_axi_shutdown_mana_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x80090000 [get_bd_addr_spaces zynq_us/Data] [get_bd_addr_segs shutdown_HP0_FPD/S_AXI_CTRL/Reg] SEG_shutdown_HP0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x800D0000 [get_bd_addr_spaces zynq_us/Data] [get_bd_addr_segs shutdown_HP2_FPD/S_AXI_CTRL/Reg] SEG_shutdown_HP2_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x80000000 [get_bd_addr_spaces zynq_us/Data] [get_bd_addr_segs video/hdmi_in/frontend/S_AXI_CPU_IN/Reg] SEG_v_hdmi_rx_ss_Reg
  create_bd_addr_seg -range 0x00020000 -offset 0x80020000 [get_bd_addr_spaces zynq_us/Data] [get_bd_addr_segs video/hdmi_out/frontend/S_AXI_CPU_IN/Reg] SEG_v_hdmi_tx_ss_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x800E0000 [get_bd_addr_spaces zynq_us/Data] [get_bd_addr_segs video/hdmi_out/v_mix_0/s_axi_CTRL/Reg] SEG_v_mix_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x800F0000 [get_bd_addr_spaces zynq_us/Data] [get_bd_addr_segs video/hdmi_out/v_tpg_0/s_axi_CTRL/Reg] SEG_v_tpg_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x80060000 [get_bd_addr_spaces zynq_us/Data] [get_bd_addr_segs video/phy/vid_phy_controller/vid_phy_axi4lite/Reg] SEG_vid_phy_controller_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40000000 [get_bd_addr_spaces iop_pmod0/mb/Data] [get_bd_addr_segs iop_pmod0/gpio/S_AXI/Reg] SEG_gpio_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40800000 [get_bd_addr_spaces iop_pmod0/mb/Data] [get_bd_addr_segs iop_pmod0/iic/S_AXI/Reg] SEG_iic_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41200000 [get_bd_addr_spaces iop_pmod0/mb/Data] [get_bd_addr_segs iop_pmod0/intc/S_AXI/Reg] SEG_intc_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40010000 [get_bd_addr_spaces iop_pmod0/mb/Data] [get_bd_addr_segs iop_pmod0/intr/S_AXI/Reg] SEG_intr_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x44A20000 [get_bd_addr_spaces iop_pmod0/mb/Data] [get_bd_addr_segs iop_pmod0/io_switch/S_AXI/S_AXI_reg] SEG_io_switch_S_AXI_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x00000000 [get_bd_addr_spaces iop_pmod0/mb/Data] [get_bd_addr_segs iop_pmod0/lmb/lmb_bram_if_cntlr/SLMB1/Mem] SEG_lmb_bram_if_cntlr_Mem
  create_bd_addr_seg -range 0x00010000 -offset 0x00000000 [get_bd_addr_spaces iop_pmod0/mb/Instruction] [get_bd_addr_segs iop_pmod0/lmb/lmb_bram_if_cntlr/SLMB/Mem] SEG_lmb_bram_if_cntlr_Mem
  create_bd_addr_seg -range 0x00010000 -offset 0x44A10000 [get_bd_addr_spaces iop_pmod0/mb/Data] [get_bd_addr_segs iop_pmod0/spi/AXI_LITE/Reg] SEG_spi_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41C00000 [get_bd_addr_spaces iop_pmod0/mb/Data] [get_bd_addr_segs iop_pmod0/timer/S_AXI/Reg] SEG_timer_Reg
  create_bd_addr_seg -range 0x80000000 -offset 0x80000000 [get_bd_addr_spaces iop_pmod0/mb/Data] [get_bd_addr_segs zynq_us/SAXIGP6/LPD_DDR_LOW] SEG_zynq_us_LPD_DDR_LOW
  create_bd_addr_seg -range 0x00010000 -offset 0x40000000 [get_bd_addr_spaces iop_pmod1/mb/Data] [get_bd_addr_segs iop_pmod1/gpio/S_AXI/Reg] SEG_axi_gpio_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40800000 [get_bd_addr_spaces iop_pmod1/mb/Data] [get_bd_addr_segs iop_pmod1/iic/S_AXI/Reg] SEG_axi_iic_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x44A10000 [get_bd_addr_spaces iop_pmod1/mb/Data] [get_bd_addr_segs iop_pmod1/spi/AXI_LITE/Reg] SEG_axi_quad_spi_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x00000000 [get_bd_addr_spaces iop_pmod1/mb/Instruction] [get_bd_addr_segs iop_pmod1/lmb/lmb_bram_if_cntlr/SLMB/Mem] SEG_ilmb_bram_if_cntlr_Mem
  create_bd_addr_seg -range 0x00010000 -offset 0x44A20000 [get_bd_addr_spaces iop_pmod1/mb/Data] [get_bd_addr_segs iop_pmod1/io_switch/S_AXI/S_AXI_reg] SEG_io_switch_0_S_AXI_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x00000000 [get_bd_addr_spaces iop_pmod1/mb/Data] [get_bd_addr_segs iop_pmod1/lmb/lmb_bram_if_cntlr/SLMB1/Mem] SEG_lmb_bram_if_cntlr_Mem
  create_bd_addr_seg -range 0x00010000 -offset 0x41200000 [get_bd_addr_spaces iop_pmod1/mb/Data] [get_bd_addr_segs iop_pmod1/intc/S_AXI/Reg] SEG_mb1_intc_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41C00000 [get_bd_addr_spaces iop_pmod1/mb/Data] [get_bd_addr_segs iop_pmod1/timer/S_AXI/Reg] SEG_mb1_timer_Reg
  create_bd_addr_seg -range 0x80000000 -offset 0x80000000 [get_bd_addr_spaces iop_pmod1/mb/Data] [get_bd_addr_segs zynq_us/SAXIGP6/LPD_DDR_LOW] SEG_zynq_us_LPD_DDR_LOW
  create_bd_addr_seg -range 0x00010000 -offset 0x40010000 [get_bd_addr_spaces iop_pmod1/mb/Data] [get_bd_addr_segs iop_pmod1/intr/S_AXI/Reg] pmod1_intr_Reg
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces video/axi_vdma/Data_S2MM] [get_bd_addr_segs zynq_us/SAXIGP3/HP1_DDR_LOW] SEG_zynq_us_HP1_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces video/axi_vdma/Data_S2MM] [get_bd_addr_segs zynq_us/SAXIGP3/HP1_QSPI] SEG_zynq_us_HP1_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces video/axi_vdma/Data_MM2S] [get_bd_addr_segs zynq_us/SAXIGP5/HP3_DDR_LOW] SEG_zynq_us_HP3_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces video/axi_vdma/Data_MM2S] [get_bd_addr_segs zynq_us/SAXIGP5/HP3_QSPI] SEG_zynq_us_HP3_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces video/hdmi_out/v_mix_0/Data_m_axi_mm_video1] [get_bd_addr_segs zynq_us/SAXIGP2/HP0_DDR_LOW] SEG_zynq_us_HP0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces video/hdmi_out/v_mix_0/Data_m_axi_mm_video5] [get_bd_addr_segs zynq_us/SAXIGP2/HP0_DDR_LOW] SEG_zynq_us_HP0_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces video/hdmi_out/v_mix_0/Data_m_axi_mm_video1] [get_bd_addr_segs zynq_us/SAXIGP2/HP0_QSPI] SEG_zynq_us_HP0_QSPI
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces video/hdmi_out/v_mix_0/Data_m_axi_mm_video5] [get_bd_addr_segs zynq_us/SAXIGP2/HP0_QSPI] SEG_zynq_us_HP0_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces video/hdmi_out/v_mix_0/Data_m_axi_mm_video4] [get_bd_addr_segs zynq_us/SAXIGP3/HP1_DDR_LOW] SEG_zynq_us_HP1_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces video/hdmi_out/v_mix_0/Data_m_axi_mm_video3] [get_bd_addr_segs zynq_us/SAXIGP4/HP2_DDR_LOW] SEG_zynq_us_HP2_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces video/hdmi_out/v_mix_0/Data_m_axi_mm_video3] [get_bd_addr_segs zynq_us/SAXIGP4/HP2_QSPI] SEG_zynq_us_HP2_QSPI

  # Exclude Address Segments
  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces filter_pipeline_0/Data_m_axi_frame] [get_bd_addr_segs zynq_us/SAXIGP0/HPC0_LPS_OCM] SEG_zynq_us_HPC0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs filter_pipeline_0/Data_m_axi_frame/SEG_zynq_us_HPC0_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces iop_pmod0/mb/Data] [get_bd_addr_segs zynq_us/SAXIGP6/LPD_LPS_OCM] SEG_zynq_us_LPD_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs iop_pmod0/mb/Data/SEG_zynq_us_LPD_LPS_OCM]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces iop_pmod0/mb/Data] [get_bd_addr_segs zynq_us/SAXIGP6/LPD_QSPI] SEG_zynq_us_LPD_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs iop_pmod0/mb/Data/SEG_zynq_us_LPD_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces iop_pmod1/mb/Data] [get_bd_addr_segs zynq_us/SAXIGP6/LPD_LPS_OCM] SEG_zynq_us_LPD_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs iop_pmod1/mb/Data/SEG_zynq_us_LPD_LPS_OCM]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces iop_pmod1/mb/Data] [get_bd_addr_segs zynq_us/SAXIGP6/LPD_QSPI] SEG_zynq_us_LPD_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs iop_pmod1/mb/Data/SEG_zynq_us_LPD_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces optical_flow_0/Data_m_axi_curr_frame] [get_bd_addr_segs zynq_us/SAXIGP4/HP2_LPS_OCM] SEG_zynq_us_HP2_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs optical_flow_0/Data_m_axi_curr_frame/SEG_zynq_us_HP2_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces optical_flow_0/Data_m_axi_out_frame] [get_bd_addr_segs zynq_us/SAXIGP5/HP3_LPS_OCM] SEG_zynq_us_HP3_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs optical_flow_0/Data_m_axi_out_frame/SEG_zynq_us_HP3_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces optical_flow_0/Data_m_axi_prev_frame] [get_bd_addr_segs zynq_us/SAXIGP5/HP3_LPS_OCM] SEG_zynq_us_HP3_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs optical_flow_0/Data_m_axi_prev_frame/SEG_zynq_us_HP3_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces video/axi_vdma/Data_MM2S] [get_bd_addr_segs zynq_us/SAXIGP5/HP3_LPS_OCM] SEG_zynq_us_HP3_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs video/axi_vdma/Data_MM2S/SEG_zynq_us_HP3_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces video/axi_vdma/Data_S2MM] [get_bd_addr_segs zynq_us/SAXIGP3/HP1_LPS_OCM] SEG_zynq_us_HP1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs video/axi_vdma/Data_S2MM/SEG_zynq_us_HP1_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces video/hdmi_out/v_mix_0/Data_m_axi_mm_video1] [get_bd_addr_segs zynq_us/SAXIGP2/HP0_LPS_OCM] SEG_zynq_us_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs video/hdmi_out/v_mix_0/Data_m_axi_mm_video1/SEG_zynq_us_HP0_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces video/hdmi_out/v_mix_0/Data_m_axi_mm_video3] [get_bd_addr_segs zynq_us/SAXIGP4/HP2_LPS_OCM] SEG_zynq_us_HP2_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs video/hdmi_out/v_mix_0/Data_m_axi_mm_video3/SEG_zynq_us_HP2_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces video/hdmi_out/v_mix_0/Data_m_axi_mm_video4] [get_bd_addr_segs zynq_us/SAXIGP3/HP1_LPS_OCM] SEG_zynq_us_HP1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs video/hdmi_out/v_mix_0/Data_m_axi_mm_video4/SEG_zynq_us_HP1_LPS_OCM]

  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces video/hdmi_out/v_mix_0/Data_m_axi_mm_video4] [get_bd_addr_segs zynq_us/SAXIGP3/HP1_QSPI] SEG_zynq_us_HP1_QSPI
  exclude_bd_addr_seg [get_bd_addr_segs video/hdmi_out/v_mix_0/Data_m_axi_mm_video4/SEG_zynq_us_HP1_QSPI]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces video/hdmi_out/v_mix_0/Data_m_axi_mm_video5] [get_bd_addr_segs zynq_us/SAXIGP2/HP0_LPS_OCM] SEG_zynq_us_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs video/hdmi_out/v_mix_0/Data_m_axi_mm_video5/SEG_zynq_us_HP0_LPS_OCM]



  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


