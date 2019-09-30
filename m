From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH] multipathd: warn when configuration has been
	changed.
Date: Mon, 30 Sep 2019 11:12:02 -0500
Message-ID: <20190930161202.GB25414@octiron.msp.redhat.com>
References: <1569266956-6339-1-git-send-email-bmarzins@redhat.com>
	<6af607515513ef1a39869aed35c15774046a1bda.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <6af607515513ef1a39869aed35c15774046a1bda.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <Martin.Wilck@suse.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Sep 27, 2019 at 03:59:05PM +0000, Martin Wilck wrote:
> On Mon, 2019-09-23 at 14:29 -0500, Benjamin Marzinski wrote:
> > It would be helpful if multipathd could log a message when
> > multipath.conf or files in the config_dir have been written to, both
> > so
> > that it can be used to send a notification to users, and to help with
> > determining after the fact if multipathd was running with an older
> > config, when the logs of multipathd's behaviour don't match with the
> > current multipath.conf.
> > 
> > To do this, the multipathd uxlsnr thread now sets up inotify watches
> > on
> > both /etc/multipath.conf and the config_dir to watch if the files are
> > deleted or closed after being opened for writing.  In order to keep
> > uxlsnr from polling repeatedly if the multipath.conf or the
> > config_dir
> > aren't present, it will only set up the watches once per reconfigure.
> > However, since multipath.conf is far more likely to be replaced by a
> > text editor than modified in place, if it gets removed, multipathd
> > will
> > immediately try to restart the watch on it (which will succeed if the
> > file was simply replaced by a new copy).  This does mean that if
> > multipath.conf or the config_dir are actually removed and then later
> > re-added, multipathd won't log any more messages for changes until
> > the
> > next reconfigure. But that seems like a fair trade-off to avoid
> > repeatedly polling for files that aren't likely to appear.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/config.h |   1 +
> >  multipathd/main.c     |   1 +
> >  multipathd/uxlsnr.c   | 134
> > ++++++++++++++++++++++++++++++++++++++++--
> >  3 files changed, 130 insertions(+), 6 deletions(-)
> > 
> 
> So, next, after we get a notification, we wait a few seconds and call
> reconfigure() automatically? Well I guess before we do that we should
> implement a dry-run with a syntax check...

I'm not sure if multipathd should autoreconfigure.  Since multipath maps
can end up changing there, I think it still makes sense that it should
only happen when specifically requested by the user. But it would be
nice to see if a reconfigure should have happened in the logs, and users
are free to set up their own policies triggered off the message.
 
> I found one minor issue, see below. Otherwise, ACK.
> 
> Thanks,
> Martin
> 
> > +void handle_inotify(int fd, int  *wds)
> > +{
> > +	char buff[1024]
> > +		__attribute__ ((aligned(__alignof__(struct
> > inotify_event))));
> > +	const struct inotify_event *event;
> > +	ssize_t len;
> > +	char *ptr;
> > +	int i, got_notify = 0;
> > +
> > +	for (;;) {
> > +		len = read(fd, buff, sizeof(buff));
> > +		if (len <= 0) {
> > +			if (len < 0 && errno != EAGAIN) {
> > +				condlog(3, "error reading from
> > inotify_fd");
> > +				for (i = 0; i < 2; i++) {
> > +					if (wds[i] != -1) {
> > +						inotify_rm_watch(fd,
> > wds[0]);
> 
> Should this be wds[i] instead?

Oops. Thanks for catching that. I'll resend the patch

-Ben
