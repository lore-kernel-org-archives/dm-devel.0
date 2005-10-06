From: Eduard Bloch <edi@gmx.de>
Subject: Re: Strange data corruption with RW snapshots
Date: Thu, 6 Oct 2005 18:59:24 +0200
Message-ID: <20051006165924.GA22504@debian>
References: <20051001112009.GC24685@debian>
	<200510051049.31055.kevcorry@us.ibm.com>
	<20051005161610.GA5696@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20051005161610.GA5696@debian>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

#include <hallo.h>
* Eduard Bloch [Wed, Oct 05 2005, 06:16:10PM]:
> #include <hallo.h>
> * Kevin Corry [Wed, Oct 05 2005, 10:49:30AM]:

> So I must assume there is something wrong with the cloop driver, and
> dm-snapshot is the only way to reproduce that. The symptoms look similar
> to non-reentrant programs, but I didn't try to inspect the exact
> behaviour of dm-snapshot when reading from cloop device yet.

The problem was in the cloop driver, it has also been found and fixed by
the Ubuntu guys without telling anyone else. The new packages of cloop
will solve the problem. Sorry for the noise.

Eduard.
-- 
Wer viel spricht hat weniger Zeit zum Denken.
		-- Indisches Sprichwort
