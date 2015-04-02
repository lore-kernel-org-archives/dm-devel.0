From: Dennis Yang <shinrairis@gmail.com>
Subject: dm-thin: delete device could take lots of time
Date: Thu, 2 Apr 2015 18:28:57 +0800
Message-ID: <CAKTMprOpXsF7duNf5UcdQJS3nNDYi08LQppKij4w5F6QScnBpw@mail.gmail.com>
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

Hi,

I had noticed that deleting a large fully mapped thin device (> 10TB)
on a pool with small block size could take couple of minutes, for it
needs to traverse all the way down to the tree to decrement the
reference count of all mapped blocks. Since deleting device needs to
take "pmd->root_lock" write lock, I/O will hang since it also need to
held this lock for finding block mapping, provisioning blocks, or
breaking shared blocks. Some applications will treat the long I/O
response time as I/O error and the service will become offline. I had
traced the code and wished to find a way to release this lock every
couple of seconds when deleting a large thin device. However, since I
cannot figure out any elegant and formal way to do so. I am wondering
if someone can shed some light on this problem. Is there any way I can
pull this off nice and clean?

Any help would be grateful.
Thanks for your patience.

Dennis
