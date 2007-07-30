From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: CVS pull of device mapper
Date: Mon, 30 Jul 2007 17:49:47 -0400
Message-ID: <170fa0d20707301449x20b8e5c6pa5abda60514a0be@mail.gmail.com>
References: <1185821641.4547.5.camel@linux-cxyg>
	<D44F48C7D79D2943A073C8FA0F49A3CC012B36D4@orsmsx418.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <D44F48C7D79D2943A073C8FA0F49A3CC012B36D4@orsmsx418.amr.corp.intel.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 7/30/07, Wood, Brian J <brian.j.wood@intel.com> wrote:
> Hello everyone, I've just built a test system with Fedora 7 and am
> having a problem with running dmeventd after getting the latest pull
> from the CVS tree. From the "make" and "make install" commands
> everything is error free, but when I run the dmeventd daemon I get this
> error:
>
> /sbin/dmeventd: error while loading shared libraries:
> libdevmapper-event.so.1.02: cannot open shared object file: No such file
> or directory
>
> I've looked in /lib and there is an instance of
> libdevmapper-event.so.1.02 (and a symbolic link named
> libdevmapper-event.so), so I'm confused as to why the daemon can't find
> them? When I run configure the only parameters I'm passing in are
> "--enable-debug" and "--enable-dmeventd"

Try using ldconfig (-v can be useful) and ldd /sbin/dmeventd
