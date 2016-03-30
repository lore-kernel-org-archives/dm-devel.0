From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH 01/17] multipathd: use /run instead of
	/var/run
Date: Wed, 30 Mar 2016 12:06:06 -0400
Message-ID: <22267.63854.100839.574128@quad.stoffel.home>
References: <1459221194-23222-1-git-send-email-bmarzins@redhat.com>
	<1459221194-23222-2-git-send-email-bmarzins@redhat.com>
	<22266.35269.520687.195696@quad.stoffel.home>
	<20160330004108.GG2915@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160330004108.GG2915@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, John Stoffel <john@stoffel.org>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

>>>>> "Benjamin" == Benjamin Marzinski <bmarzins@redhat.com> writes:

Benjamin> On Tue, Mar 29, 2016 at 09:57:25AM -0400, John Stoffel wrote:
>> 
Benjamin> /var/run is now usually a symlink to /run.  If /var is on a separate
Benjamin> filesytem, when multipathd starts up, it might end up writing to
Benjamin> /var/run before the /var filesytem is mounted and thus not have its
Benjamin> pidfile accessible at /var/run afterwards.  On most distrubutions /run
Benjamin> is now a tmpfs and should always be available before multipathd is
Benjamin> started, so multipath should just write there directly, instead of
Benjamin> through the symlink.
>> 
>> I'm not sure I agree with this, it really smells more like a
>> distribution problem, than a multipathd problem.  If multipathd starts
>> up in an initramfs, how does it get reset to the proper /var/run or
>> /run directory then?

Benjamin> Huh? /run is a tmpfs on almost all distros now. It gets
Benjamin> remounted when you switch the root from the initramfs, but
Benjamin> it doesn't go away. So there isn't a "proper" /run that
Benjamin> appears later. /var/run just gets symlinked to it.

Gah!  I apologize for the noise, I did a quick check on some RHEL5/6
systems (which are ancient I agree!) and didn't look at newer
debian/mint systems as well.  And I do see that /run is there.  

John
