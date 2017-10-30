From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Pushing the multipath state info into the fabric
Date: Mon, 30 Oct 2017 15:17:22 -0400
Message-ID: <20171030191722.GA13837@redhat.com>
References: <003dec9a190f45aa91bff7e0010968e1@BRMWP-EXMB12.corp.brocade.com>
	<20171026143532.GA5490@redhat.com>
	<9a527555006647c6b4586fe78cf6d7b1@BRMWP-EXMB12.corp.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <9a527555006647c6b4586fe78cf6d7b1@BRMWP-EXMB12.corp.brocade.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Muneendra Kumar M <mmandala@Brocade.com>
Cc: Todd Gill <tgill@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Gris Ge <fge@redhat.com>
List-Id: dm-devel.ids

(please don't top-post once someone establishes bottom-posting)

On Mon, Oct 30 2017 at 12:40am -0400,
Muneendra Kumar M <mmandala@Brocade.com> wrote:

> Hi Mike,
> Our intention is to train the multipathd for pushing the  multipath
> info into the fabric using LIBHBA api's. 
> Can we call libhba apis in multipathd to push the info into fabric?

I'll defer to others who maintain and develop multipathd but I'll say
that I think it'd be more logical/correct to _not_ code multipathd to do
this directly.  But rather have your own code that interfaces with
multipathd to get the multipath info and push it where you'd like.

Newer multipathd code that was added to make programmatic access to
multipathd state easier/possible includes:

1) multipathd show maps json
   multipathd show map $map json

2) Use libdmmp (see multipath-tools commit 4335abb36f33f1).  libdmmp
   provides access to the json output via C api.

(thanks to Todd and Gris for providing pointers to these interfaces)

Mike
