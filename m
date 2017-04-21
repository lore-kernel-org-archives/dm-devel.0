From: Andrei Borzenkov <arvidjaar@gmail.com>
Subject: Autoload of DM kernel targets?
Date: Fri, 21 Apr 2017 06:45:05 +0300
Message-ID: <3474bd1a-7a81-29ba-3562-aaaaeca47cc7@gmail.com>
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

See as example https://bugzilla.opensuse.org/show_bug.cgi?id=983221

"non-standard" DM targets do not appear to be autoloaded (the problem
was hit with thin-pool, but it seems to apply to other targets as well).
"Common" targets (like linear) are provided by dm-mod which seems to be
autoloaded by virtue of /dev/mapper/control.

Is it expected and intentional? Or are users required to manually load
necessary modules on boot?

TIA

-andrei
