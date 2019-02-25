From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: bug: dmsetup fails to parse concise tables
Date: Mon, 25 Feb 2019 13:19:50 +0000
Message-ID: <20190225131950.GA4669@agk-dp.fab.redhat.com>
References: <0b154688-762c-b6ac-2925-4ee8a19962a2@garloff.de>
	<424c7a6d-f0c6-e2d6-2e1a-bb9fac328046@garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <424c7a6d-f0c6-e2d6-2e1a-bb9fac328046@garloff.de>
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

On Sat, Feb 23, 2019 at 11:01:45PM +0100, Kurt Garloff wrote:
> Fixing patch is attached. The parser not never get to the third entry ...

Try this.

Alasdair

--- a/tools/dmsetup.c
+++ b/tools/dmsetup.c
@@ -369,7 +369,7 @@ static int _parse_table_lines(struct dm_task *dmt)
 
 	do {
 		/* Identify and terminate each line */
-		if ((next_pos = strchr(_table, '\n')))
+		if ((next_pos = strchr(pos, '\n')))
 			*next_pos++ = '\0';
 		if (!_parse_line(dmt, pos, "", ++line))
 			return_0;
