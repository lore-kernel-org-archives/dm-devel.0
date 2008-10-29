From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1/9] dm snapshot: make chunk_io handle any
	buffer
Date: Wed, 29 Oct 2008 23:48:52 +0000
Message-ID: <20081029234852.GM31233@agk.fab.redhat.com>
References: <1225109276-16491-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1225109276-16491-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1225109276-16491-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Oct 27, 2008 at 09:07:48PM +0900, FUJITA Tomonori wrote:
> chunk_io() can perform I/Os only with ps->area. This patch adds a new
> argument (a pointer to a buffer) to chunk_io() so that it can performs
> I/Os with the buffer.
 
> +static int chunk_io(struct pstore *ps, chunk_t chunk, int rw, int metadata,
> +		    void *data)

data is part of ps so should not need passing in as it's already accessible!

It's looking like struct pstore is acquiring fields that apply to only one
type of snapshot:  IOW More-invasive refactoring of that struct is needed.
- Which fields apply to both?  Which apply only to one type of snapshot?

Alasdair
-- 
agk@redhat.com
