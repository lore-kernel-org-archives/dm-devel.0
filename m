From: Joe Thornber <thornber@redhat.com>
Subject: Re: Make the mq policy an alias for smq
Date: Thu, 11 Feb 2016 10:00:39 +0000
Message-ID: <20160211100038.GA4797@rh-vpn>
References: <1455100523-16922-1-git-send-email-ejt@redhat.com>
	<20160211021305.GB4481@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160211021305.GB4481@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Joe Thornber <ejt@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Feb 10, 2016 at 09:13:05PM -0500, Mike Snitzer wrote:
> Or is this some subtle compatability so that "mq" is always displayed
> in cache status output?

This is about auto loading the smq module if someone asks for mq.
