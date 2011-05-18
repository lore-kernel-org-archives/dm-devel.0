From: Groshev Dmitry <a2alt@ya.ru>
Subject: dm snapshot diffs
Date: Wed, 18 May 2011 22:47:28 +0400
Message-ID: <120681305744449@web11.yandex.ru>
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
List-Id: dm-devel.ids

Hello. I' m using LVM with snapshots on a big storage and for some reason I need to get some information that bare LVM doesn't provide. Is there a way to get a list of blocks that was changed since the snapshot was created? I see that snapshot-cow device if being filled, but how I can find a "old block in origin -> new block in cow" mapping?
