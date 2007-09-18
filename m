From: Tore Anderson <tore@linpro.no>
Subject: Re: path priorities on Sun's 6140
Date: Tue, 18 Sep 2007 09:39:38 +0200
Message-ID: <46EF80BA.1020605@linpro.no>
References: <66F461DD7EDEEF4AA928FCC80B425B520468B7@c2kp01mail.cucbc.com><46EBA114.10408@linpro.no>	<66F461DD7EDEEF4AA928FCC80B425B520468B8@c2kp01mail.cucbc.com>
	<66F461DD7EDEEF4AA928FCC80B425B520468B9@c2kp01mail.cucbc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <66F461DD7EDEEF4AA928FCC80B425B520468B9@c2kp01mail.cucbc.com>
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

* James Fillman

> Ok. So I just realized that if I want to try the new RDAC support,
> then I have to install the new beta kernel as well. It includes the
> RDAC hardware handler.
> 
> I'm under serious pressure to get my cluster up and running asap and
> I don't think I want to be installing a bunch of beta packages onto
> my production servers. Especially kernels.

To me the benefit of RDAC mode would far outweigh the disadvantage of
knowing you're running a beta kernel, but that's your call...

With AVT mode you will have I/O interruptions and volume failovers when
a node in your cluster boots.  It's unavoidable.  You'll probably want
to test really well how the rest of the cluster behaves in such situations.

> So this might mean not exploring the RDAC solution. Redhat's docs say
> that they support a Sun OpenStorage D280 and our Sun rep says the
> 6140 is essentially identical. If that's the case, what am I don't
> wrong?

The original hardware is called Engenio 3994 - you might be able to
confirm that the D280 is the same by Googling some.  (The IBM DS4700
model 72 is also the same, by the way).  RH probably supports it in AVT
mode.  Your configuration looks okay to me, different
path_grouping_policy then what I use but as long as the prio_callout
works correctly the end result should be the same.  My config looks like
this on a RHEL4 box running in AVT mode:

device {
        vendor                  SUN.*
        product                 CSM200_R.*
        path_grouping_policy    group_by_serial
        path_checker            tur
        prio_callout            "/usr/local/sbin/mpath_prio_tpc /dev/%n"
        failback                immediate
        no_path_retry           queue
}

This gives me output from 'multipath -ll' like this in a dual fabric
topology:

nfs_ny (3600a0b80002625ae0000080745dbe5ca)
[size=100 GB][features="1 queue_if_no_path"][hwhandler="0"]
\_ round-robin 0 [prio=2][enabled]
 \_ 1:0:0:1 sdc 8:32  [active][ready]
 \_ 2:0:1:1 sdi 8:128 [active][ready]
\_ round-robin 0 [prio=12][active]
 \_ 1:0:1:1 sde 8:64  [active][ready]
 \_ 2:0:0:1 sdg 8:96  [active][ready]

SCSI targets 1:0:0 and 2:0:1 are to controller A, 1:0:1 and 2:0:0 are to
controller B (the preferred one for LUN 1).  I can verify that the
prio_callout works correctly by testing one path:

$ /usr/local/sbin/mpath_prio_tpc /dev/sde
6

Did you try host type AIX_FO, by the way?  That was the one I found to
work the best with AVT mode.

Regards
-- 
Tore Anderson
