From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 0/6] libmultipath: check udev* func return
	value
Date: Fri, 18 Sep 2020 09:37:22 +0200
Message-ID: <011310221c816f3c3573d96d91aca3e0a48fb80d.camel@suse.com>
References: <d89bc33d-8e5d-d194-3b26-83ff4d170c5c@huawei.com>
	<20200918022626.GU11108@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200918022626.GU11108@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, lixiaokeng <lixiaokeng@huawei.com>
Cc: dm-devel, list <dm-devel@redhat.com>, linfeilong <linfeilong@huawei.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

On Thu, 2020-09-17 at 21:26 -0500, Benjamin Marzinski wrote:
> On Tue, Sep 15, 2020 at 12:38:27PM +0800, lixiaokeng wrote:
> > Hi,
> >   The udev* function may return NULL,and it will be
> > dereferenced in str* and sscanf func. For example,
> > there is a coredump caused in add func, which show in
> > be7a043(commit id) in upstream-queue. We check the
> > return value to avoid dereference NULL.
> > 
> > repo: openSUSE/multipath-tools
> > repo link: https://github.com/openSUSE/multipath-tools
> > branch: upstream-queue
> > 
> For the set
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

Well, the set got the logic wrong in 3 out of 6 patches :-)

In general, as these fixes are all very similar, I would prefer
bundling them together into one patch, and I would like to make sure
(and assert in the commit message) that the set fixes
*all* possible NULL pointer dereferences related to accessing udev
properties (I haven't checked whether this is the case for the set).

Also, while I'd ack this set if the logic was correct, I think that in
a way it's papering over the actual problem. udev_device_get_XYZ()
functions fail *only* if the underlying sysfs directory has vanished
(well, perhaps for out-of-memory, too, but let's put that aside for a
moment). It that case, we should actually not just return an error code
- we should realize that there's a problem with the device (it probably
has been deleted from the system and shouldn't be used any more in any
way), and that we need to deal with it somehow. This is a fundamental
problem for all user space programs that use udev_devices for more than
a few CPU cycles. That doesn't mean the set is wrong, but we should
keep this in mind. I have something cooking for a more complete
solution, which isn't ready yet.

Finally, @lixiaokeng, please check your inbox once more. You still
haven't fixed #11/14 of your previous series.

Regards,
Martin
