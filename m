From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] multipathd: deferred device adding
Date: Mon, 14 Nov 2016 15:19:04 +0000
Message-ID: <BLUPR02MB168378B12ED503A3C5CCBFB081BC0@BLUPR02MB1683.namprd02.prod.outlook.com>
References: <1478790321-8539-1-git-send-email-gi-oh.kim@profitbricks.com>
	<5a8c5ffb-2dae-0e5c-3341-1f02ab3cd4dc@suse.de>
	<8806d3b0-c507-3e2b-a7ff-fed6fbdfcb0a@profitbricks.com>
	<BLUPR02MB16838FD500AD57DA92DF4C0A81BB0@BLUPR02MB1683.namprd02.prod.outlook.com>
	<4b591c27-f1eb-8859-a319-b19e2e3bd200@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
To: Gioh Kim <gi-oh.kim@profitbricks.com>, Hannes Reinecke <hare@suse.de>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "benjamin.drung@profitbricks.com" <benjamin.drung@profitbricks.com>
List-Id: dm-devel.ids

On 11/14/16 01:23, Gioh Kim wrote:
> I  consulted with target side developers in my company.
> They said there are many jobs that should be done on initiator side without disconnecting.

Hello Gioh,

Have you considered to change the ALUA state at the SCST side into 
"transitioning" for the LUN that should be ignored by multipathd?

Bart.
