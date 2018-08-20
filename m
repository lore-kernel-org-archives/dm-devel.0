From: Sverd Johnsen <sverd.johnsen@googlemail.com>
Subject: dmsetup create linear with 4 devices not possible?
Date: Mon, 20 Aug 2018 10:37:54 +0200
Message-ID: <CAGmahrTpAxpkq8DYNTC0osANpv6dBOPCHf2=qjXhqEZON=0mZg@mail.gmail.com>
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

hey how can i do the equivalent of making a lv across 4 pvs with plain dmsetup?

i want this:

# cat test.table
0 100 linear /dev/foo 0
100 100 linear /dev/bar 0

except with more than 2 devices..but it doesnt work.
