From: Joel Becker <jlbec@evilplan.org>
Subject: Re: [Lsf] Preliminary Agenda and Activities for LSF
Date: Fri, 1 Apr 2011 14:43:03 -0700
Message-ID: <20110401214302.GB25355__39423.7474691637$1301695478$gmane$org@noexit>
References: <1301373398.2590.20.camel@mulgrave.site>
	<4D91BF90.8070909@redhat.com>
	<1301445210.2731.14.camel@mingming-laptop>
	<20110330021742.GL3008@dastard>
	<E32BEFA9-15DE-4169-B313-095920A4DF7A@mit.edu>
	<4D9313E2.6080006@gmail.com> <20110401151907.GG21075@thunk.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110401151907.GG21075@thunk.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ted Ts'o <tytso@mit.edu>, Ric Wheeler <ricwheeler@gmail.com>, Dave Chinner <david@fromorbit.com>, lsf@lists.linux-foundation.org, "linux-scsi@vger.kernel.org" <linux-sc>
List-Id: dm-devel.ids

On Fri, Apr 01, 2011 at 11:19:07AM -0400, Ted Ts'o wrote:
> The closest place that we have to any official documentation about
> O_DIRECT semantics is the open(2) man page in the Linux manpages, and
> it doesn't say anything about this.  It does give a recommendation
> against not mixing buffered and O_DIRECT accesses to the same file,
> but it does promise that things will work in that case.  (Even if it
> does, do we really want to make the promise that it will always work?)

	No, we do not.  Some OSes will silently turn buffered I/O into
direct I/O if another file already has it opened O_DIRECT.  Some OSes
will fail the write, or the open, or both, if it doesn't match the mode
of an existing fd.  Some just leave O_DIRECT and buffered access
inconsistent.
	I think that Linux should strive to make the mixed
buffered/direct case work; it's the nicest thing we can do.  But we
should not promise it.

Joel

-- 

Life's Little Instruction Book #24

	"Drink champagne for no reason at all."

			http://www.jlbec.org/
			jlbec@evilplan.org
