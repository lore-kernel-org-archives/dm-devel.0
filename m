From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: simple question... to tough to answer?
Date: Thu, 15 May 2008 13:54:11 -0400
Message-ID: <20080515175411.GA12985@mars.virtualiron.com>
References: <7BC3A7DB53028743B733D298244A8C626E3A0D@sjcpexch02.citrite.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="tKW2IUtsqtDRztdT"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <7BC3A7DB53028743B733D298244A8C626E3A0D@sjcpexch02.citrite.net>
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


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 15, 2008 at 10:09:35AM -0700, Wim Colgate wrote:
> Hi,
> 
>  
> 
> I'm not quite sure why no one in the community hasn't been able to
> answer my questions. 

Probably b/c folks are too busy..

> 
>  
> 
> Simply (re)stated:
> 
>  
> 
> 1) Are there hooks for dm/multipath events to notify software?

You can also listen to the NETLINK_DM socket and parse the data.

But that complicated by the fact that there is only one
socket that the kernel uses and it cannot be shared.

> 
> 2) does path down/up fire up udev rules?

Yes. I am attaching a simple program you can use to listen to the kobject uevents
that get fired.

You can also modify it to use NETLINK_DM instead of NETLINK_KOBJECT_UEVENT  and see
what comes out.


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="listen.c"

#include <sys/socket.h>
#include <linux/netlink.h>
#include <stdio.h>
#include <string.h>
#define MAX_PAYLOAD 1024        /* maximum payload size */
struct sockaddr_nl src_addr;
int sock_fd;
static char buff[MAX_PAYLOAD];
ssize_t buflen;

int
main ()
{
  sock_fd = socket (PF_NETLINK, SOCK_DGRAM, NETLINK_KOBJECT_UEVENT);

  memset (&src_addr, 0, sizeof (src_addr));
  src_addr.nl_family = AF_NETLINK;
  src_addr.nl_pid = getpid ();  /* self pid */
  src_addr.nl_groups = 0xffffffff;

  printf ("Listen..\n");
  bind (sock_fd, (struct sockaddr *) &src_addr, sizeof (src_addr));
  printf ("Receiving..\n");
  while (1)
    {
      buflen = recv (sock_fd, &buff, sizeof (buff), 0);
      printf ("Got data: %d\n", buflen);
      int i, bufpos;
      char *key;
      for (i = 0, bufpos = 0; (bufpos < buflen) && i < MAX_PAYLOAD; i++)
        {
          key = &buff[bufpos];
          printf ("[%s]\n", key);
          bufpos += strlen (key) + 1;
        }
      memset (&buff, 0, MAX_PAYLOAD);
    }
  /* Close Netlink Socket */
  close (sock_fd);
  return 0;
}

--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--tKW2IUtsqtDRztdT--
