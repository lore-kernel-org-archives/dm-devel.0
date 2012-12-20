From: Teng-Feng Yang <shinrairis@gmail.com>
Subject: Checksum protected metadata for snapshot persistent
	exception store
Date: Thu, 20 Dec 2012 13:45:24 +0800
Message-ID: <CAKTMprOf2=80adL3f0CBVfMxFW=s5t=EwNOp0WtqhfONNgECtw@mail.gmail.com>
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

Hello,

I recently traced the code of dm-snapshot and surprisingly found out
that it seems there is no checksum in each metadata store on COW
devices.

If this is the case, how can we be sure about the correctness of the metadata?

Any help would be grateful

Best Regards
Dennis
