From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: Fixes memory leak in setup_indexes function
Date: Fri, 6 Aug 2010 08:29:21 -0400
Message-ID: <20100806122921.GB32629@redhat.com>
References: <1281087367.2262.44.camel@sbangash-desktop>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1281087367.2262.44.camel@sbangash-desktop>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Shahzad Hussain Bangash <ext-shahzad.bangash@nokia.com>
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Aug 06 2010 at  5:36am -0400,
Shahzad Hussain Bangash <ext-shahzad.bangash@nokia.com> wrote:

> Sorry for multiple patches. This patch fixes memory leak in
> setup_indexes function where memory is allocated for indexes pointer by
> dm_vcalloc with the size of NODE_size and is not freed after that
> through the end of the function.

There isn't a leak.

The 2nd loop's "t->index[i] = indexes;" takes ownership of the
dm_vcalloc'd memory.  dm_table_destroy() will later free that memory.

Your patch actually introduces a use after free bug.

Regards,
Mike
