From: Igor Yanover <igor.yanover@gmail.com>
Subject: kcopyd_client_create allocation failure on creating
	snapshots
Date: Mon, 23 May 2005 10:25:46 +0200
Message-ID: <ba31087e05052301254b142bbe@mail.gmail.com>
Reply-To: Igor Yanover <igor.yanover@gmail.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

    Hi!
    I've got the following error, while trying to create many
snapshots ( > 32 ) :
"device-mapper: : Could not create kcopyd client". After some digging,
I found out that the reason is resize_pool() in dm-io.c trying to do
mempool_resize that is probably too large. I've seen that the issue
has been raised in this list before at:
https://www.redhat.com/archives/dm-devel/2005-April/msg00080.html,
with the same conclusions, but there was no discussion and as far I
can seen, the code has not changed since. I understand that the
correct fix would be to use per-kclient pools.
Is anyone planning to work/already working on this?

     Thanks,
          Igor
