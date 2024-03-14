﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using CoarseFoodErp.CoarseFoodForm.StockManageMent;
using DevExpress.XtraEditors;
using JBaseCommon.JBaseForm;

namespace CoarseFoodErp.StockManageMent
{
    public partial class StockForm :BaseForm
    {

        #region 构造函数
        public StockForm()
        {
            InitializeComponent();
            uc_StockControl.InitForm(typeof(EditStockForm) , "用户表");
        }
        #endregion

      



    }
}