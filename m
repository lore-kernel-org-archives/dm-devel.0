From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm:for-next 8/9]
 drivers//md/dm-log-writes.c:279:17: note: in expansion of macro 'min'
Date: Tue, 24 Oct 2017 18:55:04 -0400
Message-ID: <20171024225504.GA23859@redhat.com>
References: <201710250527.qUFkoPkl%fengguang.wu@intel.com>
	<20171024215003.GA6963@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20171024215003.GA6963@linux.intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: dm-devel@redhat.com, kbuild test robot <fengguang.wu@intel.com>, kbuild-all@01.org
List-Id: dm-devel.ids

On Tue, Oct 24 2017 at  5:50pm -0400,
Ross Zwisler <ross.zwisler@linux.intel.com> wrote:
 
> So I think this just needs to be 
> 
> 					pg_datalen = min((int)datalen, PAGE_SIZE);
> 
> since the resulting pg_datalen is also an int.
> 
> Mike can you fix up, or would you like an updated patch (or follow-on patch)
> from me?

I went with: pg_datalen = min_t(int, datalen, PAGE_SIZE);

I've fixed it up and pushed it out to linux-next.

Mike
