APPNAME=bubba-status
MAJOR=0.99.0
MINOR=2
ENDING=.tar.gz
URL= http://www.excito.com/
TOPDIR=$(shell pwd)

PACKAGEDIR?=$(shell pwd)
PACKAGENAME=$(APPNAME)-$(MAJOR)-$(MINOR).$(PARCH).deb
GET=wget
UNPACK= tar zxvf
PACK=dpkg -b . 
BDIR=$(TOPDIR)/target
PARCH=$(shell dpkg-architecture -qDEB_BUILD_ARCH)

all: compilation.done


compilation.done: 
		touch compilation.done

install.done: compilation.done
		rm -rf $(BDIR)
		mkdir $(BDIR)
		cp -a src/* $(BDIR)/
		cp -r DEBIAN $(BDIR)/DEBIAN
		cd $(BDIR) && find . -name ".svn" -exec rm -rf {} \; || exit 0
		touch install.done



package: install.done $(PACKAGEDIR)/$(PACKAGENAME)

$(PACKAGEDIR)/$(PACKAGENAME):
		sed -i -e "s/ISIZE/$(shell du --exclude DEBIAN -s $(BDIR) | cut -f 1)/g"  $(BDIR)/DEBIAN/control
		sed -i -e "s/PACKAGE_MAJOR/$(MAJOR)/g" $(BDIR)/DEBIAN/control
		sed -i -e "s/PACKAGE_MINOR/$(MINOR)/g" $(BDIR)/DEBIAN/control
		sed -i -e "s/PARCH/$(PARCH)/g" $(BDIR)/DEBIAN/control
		find $(BDIR) -type d -exec chmod 0755 {} \; 
		chmod -f 0755 $(BDIR)/DEBIAN/{postinst,prerm} || exit 0
		cd $(BDIR) && fakeroot -- $(PACK) $(PACKAGEDIR)/$(PACKAGENAME)

clean:
		rm -rf target *.done
		rm -f $(PACKAGEDIR)/$(PACKAGENAME)
