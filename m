From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [Bug] kernel oops when running xfstests(ext4)
	generic/081
Date: Tue, 5 Jun 2018 04:52:27 -0400
Message-ID: <20180605085227.GA17780@kmo-pixel>
References: <20180605080835.GH28826@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180605080835.GH28826@ming.t460p>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ming Lei <ming.lei@redhat.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Tue, Jun 05, 2018 at 04:08:37PM +0800, Ming Lei wrote:
> Hi,
> 
> The following failure is triggered when running xfstests(ext4)
> generic/081 with the linus tree(4.17.0_716a685fdb89).
> 
> It might be related with recent mempool change.

Oh _fuck_, I forgot to check that the structs the mempools/biosets were being
embedded in were allocated with GFP_ZERO.

Fuckity fuck fuck. Fuck.
