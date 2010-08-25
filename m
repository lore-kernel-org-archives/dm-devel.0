From: Malahal Naineni <malahal@us.ibm.com>
Subject: Re: DM manual failback doesn't work on RHEL5
Date: Wed, 25 Aug 2010 10:44:43 -0700
Message-ID: <20100825174443.GB31610@us.ibm.com>
References: <F757EE5C3631ED4DBDFD7709119219FE03C4B50BF7@AUSX7MCPS302.AMER.DELL.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <F757EE5C3631ED4DBDFD7709119219FE03C4B50BF7@AUSX7MCPS302.AMER.DELL.COM>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Yanqing_Liu@Dell.com [Yanqing_Liu@Dell.com] wrote:
>    Hi all,
>    =A0
>    In our testing with DM RDAC stack with RHEL 5 (including 5.5 and 5.4),=
 we
>    found that manual failback doesn't work as expected.
>    =A0
>    What we did is to connect the host to Dell PowerVault 3200/i array. Af=
ter
>    everything is configured, we changed "failback" value for our device f=
rom
>    "immediate" to "manual". Then the host is rebooted for the new value to
>    take effect. However, automatic failback still happens once failed pat=
h is
>    restored. It seems failback "manual" doesn't work.

There are few cases where you need to re-build your initrd if you change
multipath.conf file. What does the loaded table say? Does it indicate
that the failback mechanism is 'manual'?

Thanks, Malahal.
