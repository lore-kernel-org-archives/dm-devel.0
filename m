From: Edward Thornber <thornber@redhat.com>
Subject: Re: Possible data corruption with dm-thin
Date: Fri, 24 Jun 2016 09:55:11 -0400
Message-ID: <20160624135510.GA13946@roamer.bos.redhat.com>
References: <CAAR726JWQ4VKOVR87QX6Tmuhu1JnCymm7coLT=TFn3BseKm8XA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAAR726JWQ4VKOVR87QX6Tmuhu1JnCymm7coLT=TFn3BseKm8XA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dennis Yang <dennisyang@qnap.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Dennis,

On Tue, Jun 21, 2016 at 03:56:26PM +0800, Dennis Yang wrote:
> So my question is, does dm-thin have any mechanism to eliminate the race
> when
> discarded block is reused right away by another device?

I'll try and recreate your scenario.  The transaction-manager will not
reallocate a block that's been freed within a transaction so that we
can always rollback.  So as long as there hasn't been a commit,
reallocation shouldn't be possible.  This is what normally guards
allocation, but in your case I think you may be onto something and we
may have to hold onto the data cell until the passdown discards are
complete.

- Joe
