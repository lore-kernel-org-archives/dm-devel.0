From: "Kyungmin Park" <kyungmin.park@samsung.com>
Subject: Where's the dm header files in distribution packages?
Date: Mon, 16 Jul 2007 11:50:48 +0900
Message-ID: <002801c7c754$1f580170$e1ac580a@swcenter.sec.samsung.co.kr>
Reply-To: kmpark@infradead.org,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
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

Hi all,

Now I'm working with device mapper framework. But I encountered the problem with dm header files.
I want to test a module on several distributions such as fedora 4, 5, 6, and 7.
But there're no dm header files in kernel header packages. So I have to install full kernel source for each system.

My questions are
1. Why the dm header files are missing in header files packages?
2. Is there any plan to move dm header files to include/linux or include/linux/dm?
3. Or other methods to compile the dm module?

If you have other options, please let me know.

Thank you,
Kyungmin Park
