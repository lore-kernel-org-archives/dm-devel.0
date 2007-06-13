From: Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: Re: [PATCH 1/3]: region based notifications for dm-io
Date: Wed, 13 Jun 2007 14:11:23 +0200
Message-ID: <OFA96D78FE.81BE23D6-ONC12572F8.005346DC-C12572F9.0042E410@de.ibm.com>
References: <20070607225744.GF25091@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070607225744.GF25091@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: Stefan Weinhuber <wein@de.ibm.com>, heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Alasdair G Kergon <agk@redhat.com> wrote on 08.06.2007 00:57:44:

> On Tue, Jun 05, 2007 at 03:05:30PM +0200, Stefan Bader wrote:
> > This patch adds the new interface to dm-io.
> 
> And also undoes some formatting, comments, variable name changes etc.
> that I made when preparing earlier patches for upstream.  Please revert
> those changes and also look at what I changed last time, and make
> similar changes to this code.
> 
Ok, I will see to modify the patch based on your comments.

> 
> -       int bi_rw;                      /* READ|WRITE - not READA */
> +       int                     bi_rw;  /* READ|WRITE + bio flags */
> 
> Do we now support READA?
> 
If I am not mistaken the only reason READA wasn't working were some
places that compared against READ or WRITE. I changed those to test
the bit values.

> 
> But before that, let's examine and understand the proposed interface
> changes in dm-io.h.  The patch is unfortunately not easy to read in its
> current form.  Adding the new interface in parallel with the old was
> appropriate previously (change to nature of interface, and we needed to
> retain the original interface in RHEL) but I don't think it works very
> well this time.
> 
The main goal of the interface changes was to have more flexibility for
the caller. Specifically it should be possible to get more information
on the outcome of a region operation (error code). At the same time I
tried to add additional notification calls for regions. But that probably
is to much for one step. So I rework the whole patch for smaller steps. If
that is okay this time I will just modify the interface without retaining
the old one for the process. I guess this will make things simpler.

Stefan
