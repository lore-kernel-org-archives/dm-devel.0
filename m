From: Philipp Kohlbecher <xt28@gmx.de>
Subject: Is ksnapd superfluous?
Date: Mon, 25 Jan 2010 13:07:50 +0100
Message-ID: <4B5D8996.2060602@gmx.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
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
List-Id: dm-devel.ids

Hello, everyone!

Looking at drivers/md/dm-snap.c, it seems to me that ksnapd (introduced 
in 2006 with commit ca3a931fd33b841cbcc5932f8eac7c43e0909242) does not 
actually do anything. It gets created, flushed, and destroyed, but no 
work ever gets cued. Looking at the file's history, it also looks like 
it has never been used in the past.

Am I getting this wrong? Should I prepare a patch that removes ksnapd or 
would that be wasted work? (Not that it would be all that much work...)

Thanks for reading!
- Philipp Kohlbecher


Please CC me--I am not subscribed to the list.
