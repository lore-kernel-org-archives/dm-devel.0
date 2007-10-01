From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: RDAC 09.01.B5.55 with RHEL4 reboot time
Date: Mon, 01 Oct 2007 10:20:29 -0700
Message-ID: <1191259229.1933.180.camel@linuxchandra>
References: <1403218a0710010540r25c03c45ndf5cf08dcbddc7e4@mail.gmail.com>
Reply-To: sekharan@us.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1403218a0710010540r25c03c45ndf5cf08dcbddc7e4@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,

The RDAC driver you are referring to is an independent driver that
supports DS4K.

Whereas the RDAC driver being talked in this mailing list works under
DM-Multipath.

Please contact your IBM contacts w.r.t the differences in behavior w.r.t
the different RDAC driver versions you have.

regards,

chandra
On Mon, 2007-10-01 at 15:40 +0300, Voiper wrote:
> Dear,
> 
> Sorry if this is not the proper list, but I have seen people here
> talking about RDAC, and some of them are IBM engineers.
> 
> We have a linux RHEL4 cluster connected to DS4800
> We have RDAC version 09.01.B5.55, and Qlogic 2300 drivers, kernel
> 2.6.9-42.ELsmp.
> We have noticed that the reboot might take 30 minutes, while with RDAC
> version 09.01.B5.30 it takes much shorter time.
> 
> Anyone has experienced this before ??
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
