From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1/3]: region based notifications for dm-io
Date: Thu, 7 Jun 2007 23:57:44 +0100
Message-ID: <20070607225744.GF25091@agk.fab.redhat.com>
References: <5201e28f0706050605o1861d942te501266671c344f4@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5201e28f0706050605o1861d942te501266671c344f4@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Stefan Bader <Stefan.Bader@de.ibm.com>
Cc: wein@de.ibm.com, heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Jun 05, 2007 at 03:05:30PM +0200, Stefan Bader wrote:
> This patch adds the new interface to dm-io.

And also undoes some formatting, comments, variable name changes etc.
that I made when preparing earlier patches for upstream.  Please revert
those changes and also look at what I changed last time, and make
similar changes to this code.

Please avoid embedding enum definitions inside structs, for example.

-       int bi_rw;                      /* READ|WRITE - not READA */
+       int                     bi_rw;  /* READ|WRITE + bio flags */

Do we now support READA?

-       io_notify_fn fn;        /* Callback for asynchronous requests */
-       void *context;          /* Passed to callback */
+       io_notify_fn                    fn;      /* Callback for async req */
+       void *                          context; /* Passed to callback */

Please don't make format changes like that.

And things like these need resolving before inclusion:

+                       //spin_lock(&sio->lock);
+       /* FIXME: This might me unnecessary. */
+       /* FIXME: really need this ? */

+       unsigned                flags;          /* Future use...  */

Why do we need that *today* rather than adding it in future when we need
it?

This first patch is large and it would be nice to see it broken down
further.   For example, get any renaming / function moving out of the
way before making substantive code changes.

But before that, let's examine and understand the proposed interface
changes in dm-io.h.  The patch is unfortunately not easy to read in its
current form.  Adding the new interface in parallel with the old was
appropriate previously (change to nature of interface, and we needed to
retain the original interface in RHEL) but I don't think it works very
well this time.

Alasdair
-- 
agk@redhat.com
