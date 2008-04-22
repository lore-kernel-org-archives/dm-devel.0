From: Domenico Viggiani <dviggiani@tiscali.it>
Subject: map in use
Date: Tue, 22 Apr 2008 11:31:15 +0200
Message-ID: <000101c8a45b$9c93a4c0$cf42e3c1@pitagora.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 'device-mapper development' <dm-devel@redhat.com>
List-Id: dm-devel.ids

I don't know if it is the best place to ask this question but this list
helped me a lot of times!

Trying to remove a map with:
 multipath -f <map>
I get "map in use", surely by LVM. Problem is that every LVM command I try
to run (vgdisplay, vgexport, vgchange), it hangs.

Only a reboot?

Thanks
-- 
Domenico Viggiani
