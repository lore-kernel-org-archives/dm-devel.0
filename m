From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Target and deduplication?
Date: Thu, 28 Jan 2016 08:56:54 -0500
Message-ID: <20160128135654.GA4960@redhat.com>
References: <CAKdSmgsZe_dfhN_7R6P7tLfkciv-9dUJKKNj16xeWYXG8aTVVA@mail.gmail.com>
	<20160128085013.GA18023@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160128085013.GA18023@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Henrik Goldman <hg@x-formation.com>, target-devel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Jan 28 2016 at  3:50am -0500,
Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Jan 28, 2016 at 12:44:25AM +0100, Henrik Goldman wrote:
> > Hello,
> > 
> > Has anyone (possibly except purestorage) managed to make target work
> > with deduplication?
> 
> The iblock drivers works perfectly fine on top of the dm-dedup driver,
> which unfortunately still hasn't made it to mainline despite looking
> rather solid.

The author(s) fell off the face of the earth.  And in testing it fell
over pretty easily.  So I really have no idea what your view of it
"looking rather solid" is based on.
