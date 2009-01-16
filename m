From: "=?GB2312?B?0Lu42Q==?=" <xiegang112@gmail.com>
Subject: How does multipath tool handle Lun remapping?
Date: Fri, 16 Jan 2009 16:42:25 +0800
Message-ID: <d364733c0901160042n65184828pcac1e7a6435b6c9c@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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

Hi,

multipath path tool use the external program, such as scsi_id in udev,
to get the id of the lun. But how does it handle the lun remapping?
For example, at first, thiere is a lun in array:lun1, it is mapped to
host with lun id 11. On the host, I use the multipath program to
generate a multipath device for this lun. Then I unmap lun1 and
another lun: lun2 which is mapped to the host with the same lun id 11.
In this situation, it seems that the multipath tool could not notice
that there is a change of lun even after recreate the multipath
device, is that true?

Thanks,

-- 
Xie Gang
