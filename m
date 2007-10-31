From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: Problem with DM hardware handler
Date: Tue, 30 Oct 2007 17:16:50 -0700
Message-ID: <20071031001650.GA20710@linux.vnet.ibm.com>
References: <110b17190710291645l42e98bc5i6089102bb1e15f9@mail.gmail.com>
	<20071030064930.GA5002@us.ibm.com>
	<110b17190710301021g75b2f3acy87a226510937361e@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <110b17190710301021g75b2f3acy87a226510937361e@mail.gmail.com>
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

Pradipmaya Maharana <pradipmaya@gmail.com> wrote:
> The handler did register okay; I saw the following message in /var/log/messages.
> 
> Oct 29 16:32:39 localhost kernel: device-mapper: multipath sample:
> version 0.0.0 loaded.
> 

I did just as you described and it worked for me. I will send you a patch
version of the changes in my version dm-emc.c dm-sample.c off list.

1.) dmesg out
...
[764248.618295] device-mapper: multipath sample: version 0.0.3 loaded
...
[764743.244154] device-mapper: multipath sample: long trespass command
will be send
[764743.288411] device-mapper: multipath sample: honor reservation bit
will not be set (default)
[764743.344077] device-mapper: multipath sample: long trespass command
will be send

2.) multipath -l
...
mpath1 (35333333000001f40) dm-2 Linux,scsi_debug
[size=8.0M][features=0][hwhandler=1 sample]
\_ round-robin 0 [prio=0][active]
 \_ 3:0:0:0 sdb 8:16  [active][undef]

3.) /etc/multipath.conf
/etc/multipath.conf
...
      device {
                vendor                  "Linux.*"
                product                 "scsi.*"
                hardware_handler        "1 sample"
        }

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
