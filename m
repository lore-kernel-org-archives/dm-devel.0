From: "Schremmer, Steven" <Steve.Schremmer@netapp.com>
Subject: Re: [PATCH 1/1] limbultipath: prefer RDAC checker
	with	detect_checker
Date: Fri, 6 Oct 2017 15:35:08 +0000
Message-ID: <BN6PR06MB2481FB5ADB2291F0854722828C710@BN6PR06MB2481.namprd06.prod.outlook.com>
References: <20170925164924.GX3145@octiron.msp.redhat.com>
	<20171005202551.10719-1-mwilck@suse.com>
	<20171005202551.10719-2-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20171005202551.10719-2-mwilck@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: Martin Wilck <mwilck@suse.de>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On Behalf Of Martin Wilck
> Sent: Thursday, October 05, 2017 3:26 PM
> To: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Martin Wilck <mwilck@suse.de>; dm-devel@redhat.com; Xose Vazquez Perez <xose.vazquez@gmail.com>
> Subject: [dm-devel] [PATCH 1/1] limbultipath: prefer RDAC checker with detect_checker
> 
> With "detect_checker yes", ALUA is used for all storage devices
> that support ALUA. But currently RDAC is still preferred for RDAC
> devices
> (https://www.redhat.com/archives/dm-devel/2017-September/msg00326.html)
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/propsel.c | 52 +++++++++++++++++++++++++++++---------------------
>  1 file changed, 30 insertions(+), 22 deletions(-)
> 

Reviewed-by: Steve Schremmer <steve.schremmer@netapp.com>
