From: heinzm@redhat.com
Subject: [PATCH 0/2] dm-raid1: [PATCH RFC] dm-raid1: keep writing
	after leg failure
Date: Wed,  8 Apr 2015 14:27:32 +0200
Message-ID: <1428496054-5837-1-git-send-email-heinzm@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

Lidong,

thanks for sending your patch proposal.

The error endio log path seems wrong, because
the patch fails the io in case "keep_log" is set and
the log is _not_ errored.

It should be failed (as the comment explains), when
"keep_log" is set and the log has failed.

See your patch rebased to 4.0.0-rc7 and mine as 1+2 of this series.

Heinz
