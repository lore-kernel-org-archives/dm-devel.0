From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: mirroring: [patch 1 of 8] device failure tolerance
Date: Thu, 30 Jun 2005 13:33:53 +0200
Message-ID: <20050630113353.GC31922@marowsky-bree.de>
References: <16a7b346170f3909d57592016a32abc0@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <16a7b346170f3909d57592016a32abc0@redhat.com>
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
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 2005-06-29T13:07:49, Jonathan E Brassow <jbrassow@redhat.com> wrote:

> This patch defines a couple more states that logs can return, and=20
> checks for those states in the mirror code.  The states are useful for=20
> logs that have cluster support.

OK. Let me just ask one question, which I'll preface with the following:

I totally love the idea of md / DM convergence. I'm not yet quite clear
how this is to be achieved, but having two separate frameworks which at
least considerable overlap doesn't make sense - this isn't like two
filesystems, this is like two VFS layers and obviously silly. So, I
appreciate movement into that direction.

However, what's going on now is that features are being added to the DM
raid code, instead of figuring out a path of convergence.

RAID code takes, that's the experience we've got with Linux so far,
quite some time to stabilize. Duplicating it definetely doesn't seem
smart, if I may be so blunt. The RAID code in md is, nowadays, very
stable, and even already has patches for faster resync etc (merged in
-mm).

md is, in certain ways, more mature, which is exemplified by md's
ability to actually provide sane logging. DM has new cool features (like
the online remapping and stuff).

Why is the approach of reinventing a wheel with a slightly different
number of edges taken?

Is it believed that DM will supersede all aspects of md one day? Ain't
that slightly silly? ;-)


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
