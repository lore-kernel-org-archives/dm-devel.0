From: syzbot <syzbot+03e5c8ebd22cc6c3a8cb@syzkaller.appspotmail.com>
Subject: Re: memory leak in bio_copy_user_iov
Date: Sun, 28 Jul 2019 17:38:00 -0700
Message-ID: <000000000000aec4ec058ec71a3d@google.com>
References: <000000000000c75fb7058ba0c0e4@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <000000000000c75fb7058ba0c0e4@google.com>
Sender: netdev-owner@vger.kernel.org
To: agk@redhat.com, axboe@kernel.dk, coreteam@netfilter.org, davem@davemloft.net, dm-devel@redhat.com, hdanton@sina.com, kaber@trash.net, kadlec@blackhole.kfki.hu, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, pablo@netfilter.org, shli@kernel.org, snitzer@redhat.com, syzkaller-bugs@googlegroups.com
List-Id: dm-devel.ids

syzbot has bisected this bug to:

commit 664820265d70a759dceca87b6eb200cd2b93cda8
Author: Mike Snitzer <snitzer@redhat.com>
Date:   Thu Feb 18 20:44:39 2016 +0000

     dm: do not return target from dm_get_live_table_for_ioctl()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13f4eb64600000
start commit:   0011572c Merge branch 'for-5.2-fixes' of git://git.kernel...
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=100ceb64600000
console output: https://syzkaller.appspot.com/x/log.txt?x=17f4eb64600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cb38d33cd06d8d48
dashboard link: https://syzkaller.appspot.com/bug?extid=03e5c8ebd22cc6c3a8cb
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13244221a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=117b2432a00000

Reported-by: syzbot+03e5c8ebd22cc6c3a8cb@syzkaller.appspotmail.com
Fixes: 664820265d70 ("dm: do not return target from  
dm_get_live_table_for_ioctl()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
