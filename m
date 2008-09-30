From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: Patch: add Dell product information into rdac device handler
Date: Tue, 30 Sep 2008 10:57:16 -0700
Message-ID: <1222797436.14830.533.camel@chandra-ubuntu>
References: <00FE57DD11E3A94893D5BD54C3358BE884BF36@AUSX3MPC128.aus.amer.dell.com>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <00FE57DD11E3A94893D5BD54C3358BE884BF36@AUSX3MPC128.aus.amer.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
To: Yanqing_Liu@Dell.com
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, mchristi@redhat.com, Shyam_Iyer@Dell.com, Charles_Rose@Dell.com
List-Id: dm-devel.ids

Acked-by: Chandra Seetharaman <sekharan@us.ibm.com>
On Tue, 2008-09-30 at 12:01 -0500, Yanqing_Liu@Dell.com wrote:
> Hi all, 
> 
> This patch is to add Dell Powervault storage arrays into device list
> for rdac device handler.
> 
> 
> --- linux-2.6.27-rc7/drivers/scsi/device_handler/scsi_dh_rdac.c.orig
> 2008-09-29 02:31:26.000000000 -0400 
> +++ linux-2.6.27-rc7/drivers/scsi/device_handler/scsi_dh_rdac.c
> 2008-09-30 02:06:26.000000000 -0400 
> @@ -590,6 +590,8 @@ 
>         {"STK", "OPENstorage D280"}, 
>         {"SUN", "CSM200_R"}, 
>         {"SUN", "LCSM100_F"}, 
> +       {"DELL", "MD3000"}, 
> +       {"DELL", "MD3000i"}, 
>         {NULL, NULL}, 
>  }; 
>  
> 
> Thanks, 
> Yanqing
> 

