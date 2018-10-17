From: "Steinar H. Gunderson" <steinar+kernel@gunderson.no>
Subject: Re: dm_cache BUG() after power loss
Date: Wed, 17 Oct 2018 16:43:14 +0200
Message-ID: <20181017144313.inmjiftle6trn7uc@sesse.net>
References: <20181009160051.xlcpnnmyvhbivglk@sesse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181009160051.xlcpnnmyvhbivglk@sesse.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On Tue, Oct 09, 2018 at 06:00:51PM +0200, Steinar H. Gunderson wrote:
> We had a power loss event, and when a server with dm-cache came up again,
> it paniced (see below for the panic text). I couldn't find any other way to
> remedy this than to blow away the metadata volume, which I assumed was safe
> as the cache is in writethrough mode (after several catastrophic events with
> dm-cache earlier, I don't trust writeback anymore). Unfortunately, this was
> seemingly not enough, as the underlying devices came back with various levels
> of corruption and eventually had to be restored from backup. (It's running
> without dm-cache now.)

Is there some other place I should report this? The machine is awfully slow
without its cache, so it's sort of annoying to run without. :-)

/* Steinar */
-- 
Homepage: https://www.sesse.net/
