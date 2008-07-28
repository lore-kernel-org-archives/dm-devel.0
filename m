From: Eduard Nicodei <omega2youall@gmail.com>
Subject: logical volumes not being detected
Date: Mon, 28 Jul 2008 12:12:32 +0300
Message-ID: <200807281212.32092.omega2youall@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
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

Hello, this is my first posting here and I'm sorry if this has already been 
discused. All I want to know is what other modules/libraries other than the 
device-mapper kernel module, lvm2 and the devmapper library do I need in 
order to have my logical volumes detected.
here's my setup: one 160GB sata2 hdd; one 320GB sata2 hdd; a minimal 
version of ubuntu (installed from debootstrap) and a custom compiled kernel 
version 2.6.26 (I should mention that the kernel doesn't contain all of the 
modules - I wanted it to provide only the features I need). I have created a 
physical volume, volume group and logical volume from another ubuntu 
installation. It is detected while using the live cd, and also if I 
boot the minimal ubuntu with another kernel that has a full set of 
features.

regards, Eduard
