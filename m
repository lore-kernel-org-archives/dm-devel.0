From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 4/4] libmultipath: trigger uevents for
 partitions, too
Date: Wed, 10 Jul 2019 10:41:53 +0000
Message-ID: <ba52db4bc532fe1f0ab4af0981c140eb4f339d68.camel@suse.com>
References: <20190709073909.32112-1-martin.wilck@suse.com>
	<20190709073909.32112-5-martin.wilck@suse.com>
	<CAAMCDeeC31_C_4_CWXucmA2zeTvVqig3CsUmikfuuJA1V5YWRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAAMCDeeC31_C_4_CWXucmA2zeTvVqig3CsUmikfuuJA1V5YWRg@mail.gmail.com>
Content-Language: en-US
Content-ID: <D7DEFD9F64B81E4D8E194345B8450CF1@namprd18.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "rogerheflin@gmail.com" <rogerheflin@gmail.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, 2019-07-09 at 11:40 -0500, Roger Heflin wrote:
> We have an observed behavior as follows:
> 
> When the host boots up, a uuid symbolic link is created pointing at
> /dev/sda1 (device for /boot)
> 
> Multipath starts up and creates an multipath device to manage
> /dev/sda
> and a udev rule deletes /dev/sda1 invalidating the symbolic link.

I suppose you are talking about 68-del-part-nodes.rules. Note that the
rules in this file can be deactivated by setting
ENV{DONT_DEL_PART_NODES}="1" in an early udev rule.

Also, the rule only removes partitions for devices that have been
detected as being eligible for multipathing.

> The symbolic link does not appear to get re-created to point to the
> new multipath device which would lead one to suspect that there was
> no
> event happening for when the multipath device is created.

That's very unlikely. You should verify that the multipath device (for
sda) is created. My patch here relates only to the case where creating
the multipath device *fails*.

If the creation of the multipath device succeeded, my patch would have
no effect on your system. In that case you should also verify that the
kpartx devices on top of it were created. I advise to boot with
"udev.log-priority=debug" and check what udev is actually doing.

> Right now our solution is a manual solution of blacklisting the
> device
> with /boot on it.
>
> Would this fix triggering an event on the multipath device partitions
> be expected to correct the above issue?

Maybe. I don't know enough details about your configuration to tell.
But if this is a device that should not be multipathed, from my point
of view, proper blacklisting via multipath.conf is the recommended way
to handle this problem. 

You can also use "find_multipaths"; please check the documentation.
Note also that since 0.7.8, blacklisting "by protocol" is possible,
which makes it possible e.g. to blacklist local SATA disks with a
simple statement.

Regards,
Martin
