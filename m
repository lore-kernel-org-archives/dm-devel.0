From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: calling dm_io
Date: Thu, 8 Nov 2012 18:04:44 +0200
Message-ID: <CALLzPKYkCC6T=azFKm-ebJhL5Mob+6dvihG3RyUU+MnJR1rw_w@mail.gmail.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello,

dm_io() does following:

	if (!io_req->notify.fn)

So it expects caller to initialize notify.fn, but in couple of places
it is not done when allocating on stack...

dm-bufio.c:dm_bufio_issue_flush()
dm-raid1.c:mirror_flush()


chunk_io() does it correctly...

	struct dm_io_request io_req = {
		....,
		.notify.fn = NULL,
	};

I wonder how raid and buf io then works. By chance...

- Dmitry
