From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [ANNOUNCE] multipath-tools-0.4.4
Date: Mon, 25 Apr 2005 11:28:09 +0200
Message-ID: <20050425092809.GE32085@marowsky-bree.de>
References: <1098021787.5433.8.camel@zezette>
	<1098269169.417641f18a234@imp1-q.free.fr>
	<1098656088.9350.88.camel@zezette>
	<1098785191.417e21a7a7c28@imp1-q.free.fr>
	<1099328918.5525.10.camel@zezette>
	<1100214617.10251.92.camel@zezette>
	<1101394541.5820.71.camel@zezette>
	<1102261392.29843.2.camel@zezette>
	<1111242459.10694.128.camel@zezette>
	<1114381619.10011.29.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1114381619.10011.29.camel@zezette>
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

On 2005-04-25T00:26:58, christophe varoqui <christophe.varoqui@free.fr> w=
rote:

> 	* the daemon sets /proc/self/oom_adj to -17, hence is=20
> 	  protected from the oom killer. Watch out for leaks.

I just cross-checked this. Quoting /usr/src/linux/fs/proc/base.c:
static ssize_t oom_adjust_write(struct file * file, const char * buf,
                                size_t count, loff_t *ppos)
{
        struct task_struct *task =3D proc_task(file->f_dentry->d_inode);
        char buffer[8], *end;
        int oom_adjust;

        if (!capable(CAP_SYS_RESOURCE))
                return -EPERM;
        memset(buffer, 0, 8);  =20
        if (count > 6)
                count =3D 6;
        if (copy_from_user(buffer, buf, count))=20
                return -EFAULT;
        oom_adjust =3D simple_strtol(buffer, &end, 0);
        if (oom_adjust < -16 || oom_adjust > 15)
                return -EINVAL;
        if (*end =3D=3D '\n')
                end++;
        task->oomkilladj =3D oom_adjust;
        if (end - buffer =3D=3D 0)=20
                return -EIO;
        return end - buffer;
}

I doubt that set_oom_adj() has ever worked, unless your kernel is differe=
nt
from mine in this regard... Checking the return value on fprintf()/fclose=
()
might have caught this earlier.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business
