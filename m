From: Alexander Benaguev <zul@sigmatrans.ru>
Subject: online disk resizing
Date: Wed, 04 Jul 2007 21:16:34 +0400
Message-ID: <468BD5F2.8040001@sigmatrans.ru>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

hi, list

I have fc-based SAN which has ability to resizing logical disks online (IBM DS4000). is this a 
method tell about resizing to host system (centOS 5) without reboot or echo "scsi 
remove(add)-single-device 0 1 2 3"? I use multipath if this matters. will apprecate any help

alexander
