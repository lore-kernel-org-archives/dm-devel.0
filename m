From: Brad Johnson <bjohnson@proficientsolutionsinc.com>
Subject: path selector question
Date: Tue, 21 Mar 2006 09:40:36 -0600
Message-ID: <1142955636.3824.11.camel@homer>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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

I am in the process of adding one or more new path selector types to the
device-mapper. While the dm-round-robin module gets automatically loaded
when multipath is started, my new module does not (I have to manually
add it with modprobe). I know there are many ways I can have this done
automatically, such as adding my own init script. But I am very curious
how the round-robin module is getting automatically loaded. I have
grepped through all the source code for multipath-tools and device-
mapper, as well as the config files for the tools. And while it might be
obvious how this is happening, I can't see it.
Any help with this will be appreciated.

Thanks,
Brad Johnson
