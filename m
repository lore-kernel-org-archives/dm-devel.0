From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: bug: dmsetup fails to parse concise tables
Date: Mon, 25 Feb 2019 14:16:09 +0000
Message-ID: <20190225141609.GB4669@agk-dp.fab.redhat.com>
References: <0b154688-762c-b6ac-2925-4ee8a19962a2@garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <0b154688-762c-b6ac-2925-4ee8a19962a2@garloff.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kurt Garloff <kurt@garloff.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sat, Feb 23, 2019 at 10:56:59PM +0100, Kurt Garloff wrote:
> if I store device-mapper tables with dmsetup table --concise, I would
> expect that dmsetup create --concise would be able to parse the tables.

That was the intention.  Thanks for reporting the bug - fix applied upstream.
 
Alasdair
