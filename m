From: John Dorminy <jdorminy@redhat.com>
Subject: Re: dm: expose dm_copy_name_and_uuid()
Date: Thu, 6 Feb 2020 19:28:04 -0500
Message-ID: <CAMeeMh82tS6TZCLzMwW7Kk+wdnMFW8WXrbe6-vLxaAvBzU1gBw@mail.gmail.com>
References: <20200201005524.23405-1-jdorminy@redhat.com>
	<20200203165402.GA11874@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200203165402.GA11874@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Feb 3, 2020 at 11:54 AM Mike Snitzer <snitzer@redhat.com> wrote:
>
> On Fri, Jan 31 2020 at  7:55pm -0500,
> John Dorminy <jdorminy@redhat.com> wrote:
>
> > While dm_device_name() returns the MAJOR:MINOR numbers of a device,
> > some targets would like to know the pretty name of a device, and
> > some targets would like to know the uuid expected for the device.
> >
> > The MAJOR:MINOR name is useful for logging, but printing the long
> > name of the device can make it easier for the user to correlate
> > messages with the device names they know in userspace.
> >
> > The UUID can be useful for devices which store a UUID on disk, and
> > would like to verify the on-disk UUID matches the UUID known by DM.
> >
> > dm_copy_name_and_uuid() appears to be the only way to get at the
> > pretty name and the UUID at present, and this change exports the
> > function for use by GPLd modules.
> >
> > Signed-off-by: John Dorminy <jdorminy@redhat.com>
> > ---
> >  drivers/md/dm-ioctl.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> > index 1e03bc89e20f..711a46015696 100644
> > --- a/drivers/md/dm-ioctl.c
> > +++ b/drivers/md/dm-ioctl.c
> > @@ -2018,7 +2018,7 @@ int dm_copy_name_and_uuid(struct mapped_device *md, char *name, char *uuid)
> >
> >       return r;
> >  }
> > -
> > +EXPORT_SYMBOL_GPL(dm_copy_name_and_uuid);
> >
> >  /**
> >   * dm_early_create - create a mapped device in early boot.
> > --
> > 2.20.1
>
> These are already available to userspace via sysfs, e.g.:
>
> # dmsetup ls
> test-test        (253:0)
> # cat /sys/block/dm-0/dm/name
> test-test
> # cat /sys/block/dm-0/dm/uuid
> LVM-IFFqf0id2DX3IgGmu6izzJW1rBoWmsC61hwGobtrD60aCMh6zJwK3uiYUS6rbNoY
>
> Verification of the UUID that a target happens to store in its ondisk
> metadata seems like it'd best be done by userspace, _before_ activating
> the DM device, no?  Or are you saying that the target would do this
> verification as part of its .ctr method?
>
> Anyway, I'm fine with exporting it.. just think the proposed usecases
> are not a "slam-dunk" for why you need it.
>

To be clear, I care more about getting the name in kernelspace than
about getting the UUID in kernelspace. (253:0) is a unique name for
test-test, and we can get that via dm_device_name() at the moment. But
test-test is often a better name -- it's the name the user provided
dmsetup in the first place, so using it in log messages can help the
user match them to the device that generated them, even after the
device has been shut down and the device number has been lost.

I would tweak dm_device_name() save that at least some of its existing
users do want the numerical name. Besides, dm_copy_name_and_uuid() is
already declared in device-mapper.h, it just isn't exported for use
yet.

With regard to the UUID, I do think that some targets would like to
check it in their .ctr() function. A userspace tool that checks the
UUID before starting the device might as well just read the UUID off
the device and then pass that into dmsetup, thus guaranteeing that
they match. But the target itself might also want to check its UUID in
kernelspace in its constructor, perhaps to warn if someone is using
the target outside of the userspace tool just mentioned and has failed
to specify the right UUID.

If it would be better to alter or tweak dm_device_name(), I'd be happy
to do that instead.

Thanks!
