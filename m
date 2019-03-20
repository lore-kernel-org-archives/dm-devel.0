From: Sahid Orentino Ferdjaoui <sahid.ferdjaoui@canonical.com>
Subject: Where to read the WWID of a multipath device
Date: Wed, 20 Mar 2019 11:28:05 +0100
Message-ID: <20190320102805.GA30538@canonical>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Hi,

The question is as indicated on title, what would be the best way to
get the WWID of a multipath device, something which would work on any
systems or storages.

My idea was to read /sys/block/dm-X/name but someone indicated to me
that may not be correct in some situation, like it seems that
/lib/udev/scsi_id would not be correct either.

To give a bit of context it's for an OpenStack library in Python.

Thanks,
s.
