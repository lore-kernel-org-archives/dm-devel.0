From: Peter Rockai <prockai@redhat.com>
Subject: Re: Question about dmevents
Date: Sun, 22 Jul 2007 10:43:17 +0200
Message-ID: <20070722084315.GA9301@mornfall.net>
References: <20070720162626.GA459@agk.fab.redhat.com>
	<D44F48C7D79D2943A073C8FA0F49A3CC0122633A@orsmsx418.amr.corp.intel.com>
	<20070720171404.GC459@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070720171404.GC459@agk.fab.redhat.com>
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

On Fri, Jul 20, 2007 at 06:14:04PM +0100, Alasdair G Kergon wrote:
> On Fri, Jul 20, 2007 at 09:57:28AM -0700, Wood, Brian J wrote:
> > Hi Alasdair, I also read in the definition of DM_DEV_CREATE that the
> > uuid is optional. Since that is the case shouldn't the failure for not
> > having a uuid in "_alloc_thread_status()" be taken out?
>  
> I don't know this code, but in general userspace code should use uuid if it is
> present.  If it isn't, it should fall back to using the name.  Whether that
> leads to sensible behaviour in this particular case, I don't know.  If it
> doesn't then it should be documented that uuid is a requirement.

Yes, the uuid here is a requirement, since it is what is used for
communication between dmeventd and other userspace components. Using
device names is, in my opinion, prone to races and therefore not quite
suitable for dmeventd. Moreover, since the dmeventd -only- gets the
uuid (from whichever other application it tries to get it), it cannot
fall back to name, not knowing it.

In fact, when using theh libdevmapper-event library, the client-side
code should already fail, if a device has no uuid. In practice, this
means that uuid-less devices cannot be monitored, but that is probably
a case that is not really important (or is it?).

I would probably prefer to just document this as requirement and keep
things as they are. Comments?

Yours, Peter.

-- 
Peter Rockai | me()mornfall!net | prockai()redhat!com
 http://blog.mornfall.net | http://web.mornfall.net

"In My Egotistical Opinion, most people's C programs should be
 indented six feet downward and covered with dirt."
     -- Blair P. Houghton on the subject of C program indentation
