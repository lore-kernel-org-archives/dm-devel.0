From: Thanos Makatos <thanos.makatos@onapp.com>
Subject: artificially break/corrupt thin pool
Date: Tue, 14 Mar 2017 12:40:54 +0000
Message-ID: <CAM2wQBs3SHUvUCmnqjs9YiuAaAg3R0vA59BEZ6-8RqZT5B7QNA@mail.gmail.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

From time to time I get the error "Check of pool foo/bar failed
(status:1). Manual repair required!" and I'm writing a script that
tries to repair the thin pool and re-activate it (lvconvert --repair
foor/bar && lvchange -ay foo/bar).

However it's hard to test as I do not usually have a broken thin pool
at hand. Is there some simple way to break the thin pool and render it
"repairable"?

-- 
Thanos Makatos
