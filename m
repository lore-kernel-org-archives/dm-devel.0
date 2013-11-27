From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [Question] dm-cache table
Date: Wed, 27 Nov 2013 02:58:05 +0000
Message-ID: <20131127025804.GM27771@agk-dp.fab.redhat.com>
References: <52932C6F.5000306@gmail.com> <20131125120512.GC10831@debian>
	<529550BC.2040009@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <529550BC.2040009@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On Wed, Nov 27, 2013 at 10:54:04AM +0900, Akira Hayakawa wrote:
> The only essential property of the table output is that it can
> recreate the same device?

There is a further constraint.

Userspace often uses the optimisation of comparing the table line output
from the existing device with a proposed new table line to determine
whether or not the table has changed and needs to be reloaded.  For
simplicity, this can be a string comparison.

As such, the output table line that corresponds to any particular
internal table state should always be defined uniquely, particularly if
there is more than input table line that leads to that same table state.
Typically this means one of two things: EITHER arbitrary choices (e.g.
the order of supplied arguments in an unordered list; device references)
are preserved between the input and output table lines OR (normally
the better option) the output is always presented in the same standard
format regardless of the input (e.g. unordered parameter lists are
output in a defined order).  This means that userspace code that is
aware of the table output definition can choose to provide input in an
exactly matching form, but the casual user is not inhibited by such 
arbitrary restrictions.

Alasdair
