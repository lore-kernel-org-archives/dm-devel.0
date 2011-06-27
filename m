From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm: use cpu_relax when busy waiting
	for	condition
Date: Mon, 27 Jun 2011 11:22:07 +0100
Message-ID: <20110627102207.GO7497@agk-dp.fab.redhat.com>
References: <20100909220716.GA27774@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20100909220716.GA27774@redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Sep 09, 2010 at 06:07:16PM -0400, Mike Snitzer wrote:
> Switch busy loops from using msleep(1) to cpu_relax().

I'd rather we didn't have any of these, but I think these should stay
as msleep.  (Would cpu_relax() even work in every case?)

Alasdair
