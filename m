From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-cache fs corruption
Date: Wed, 13 Nov 2013 09:31:30 -0500
Message-ID: <20131113143130.GA16938@redhat.com>
References: <CALwk7=z+Xc8Xrcw5jo8DtKwT9KS2gQMumtaHTws0w4+VDs2NwQ@mail.gmail.com>
	<20131113131022.GA13882@debian>
	<CALwk7=xhJBoxyvM4yw0DwFGQoOmhAxp1p9C0oid_Wh4tzxSf5w@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CALwk7=xhJBoxyvM4yw0DwFGQoOmhAxp1p9C0oid_Wh4tzxSf5w@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vladimir Smolensky <arizal@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Nov 13 2013 at  8:48am -0500,
Vladimir Smolensky <arizal@gmail.com> wrote:

> Hello Joe,
> I can provide you with the setup to test if you want.
> Problem is, 3TB cache gets filled very slowly - about 2 weeks.

We'll have to take steps to get a quicker reproducer.  But in parallel,
could you please test the latest dm-cache code that is staged for v3.13
inclusion?  Would be a great data point to have.

Please see the 'for-linus' branch of the linux-dm.git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git

(it is based on 3.12-rc5)
